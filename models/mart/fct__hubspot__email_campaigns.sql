with campaigns as (

    select *
    from {{ ref('base__hubspot__email_campaign') }}

),

events as (

    select *
    from {{ ref('stg__hubspot__email_events_aggregates') }}

),

subscriptions as (

    select *
    from {{ ref('stg__hubspot__email_subscriptions_aggregates') }}

),

conversions as (

    select *
    from {{ ref('stg__hubspot__email_conversions_aggregates') }}

),

contact as (

    select *
    from {{ ref('stg__hubspot__contacts_joins') }}

),

joins as (

    select
            events.email_send_id,
            events.email_campaign_id,
            events.email_send_at,
            events.recipient,
            events.opens,
            events.sends,
            events.deliveries,
            events.drops,
            events.clicks,
            events.forwards,
            events.deferrals,
            events.bounces,
            events.spam_reports,
            events.prints,
            subscriptions.count_subscribe_events,
            subscriptions.count_unsubscribe_events,
            subscriptions.count_spam_report_events,
            subscriptions.net_subscription_events,
            conversions.conversions,
            conversions.contact_id is not null as was_converted
    from events
    left join contact on contact.contact_email = events.recipient ---many_to_one
    left join conversions on contact.contact_id = conversions.contact_id ---one-to-one
    left join subscriptions on events.email_send_id = subscriptions.caused_by_event_id and events.recipient = subscriptions.recipient  --one-to-one
),

aggregates as (

    select
        email_campaign_id,
        min(email_send_at) as email_send_at,
        max(was_converted) as was_converted,
        sum(conversions) as conversions,
        sum(count_subscribe_events) as subscribes,
        sum(count_unsubscribe_events) as unsubscribes,
        -- sum(count_spam_report_events) as spam_reports,
        sum(net_subscription_events) as net_subscribes,
        count(distinct case when was_converted then recipient end) as total_recip_conversions,
        count(distinct case when net_subscription_events > 0 then recipient end) as total_recip_subscribes,
        ----
        {% for metric in var('email_metrics') %}
        sum({{ metric }}) as {{ metric }},
        count(distinct case when {{ metric }} > 0 then recipient end) as total_recip_{{ metric }}
        {% if not loop.last %},{% endif %}
        {% endfor %}
    from joins
    group by 1
),

final as (
    select
            campaigns.email_campaign_id,
            campaigns.email_campaign_name,
            campaigns.email_campaign_type,
            aggregates.email_send_at,
            ----total events by event type
            aggregates.opens,
            aggregates.sends,
            aggregates.deliveries,
            aggregates.drops,
            aggregates.clicks,
            aggregates.forwards,
            aggregates.deferrals,
            aggregates.bounces,
            aggregates.spam_reports,
            aggregates.prints,
            aggregates.conversions,
            aggregates.subscribes,
            aggregates.unsubscribes,
            aggregates.net_subscribes,
            aggregates.was_converted,
            ----booleans
           aggregates.total_recip_opens,
           aggregates.total_recip_sends,
           aggregates.total_recip_deliveries,
           aggregates.total_recip_drops,
           aggregates.total_recip_clicks,
           aggregates.total_recip_forwards,
           aggregates.total_recip_deferrals,
           aggregates.total_recip_bounces,
           aggregates.total_recip_spam_reports,
           aggregates.total_recip_prints,
            ---- total recipients by event type
            aggregates.total_recip_conversions,
            aggregates.total_recip_subscribes,
            aggregates.bounces + drops + deferrals as undeliveries,
            aggregates.bounces > 0 as was_bounced,
            aggregates.clicks > 0 as was_clicked,
            aggregates.deferrals > 0 as was_deferred,
            aggregates.deliveries > 0 as was_delivered,
            aggregates.forwards > 0 as was_forwarded,
            aggregates.opens > 0 as was_opened,
            aggregates.prints > 0 as was_printed,
            aggregates.spam_reports > 0 as was_spam_reported,
            aggregates.net_subscribes > 0 as was_subscribed,
            ---ratio by event type
            aggregates.opens / nullif(aggregates.sends, 0) as open_ratio,
            aggregates.clicks / nullif(aggregates.sends, 0) as click_ratio,
            aggregates.deliveries / nullif(aggregates.sends, 0) as delivered_ratio,
            aggregates.deferrals / nullif(aggregates.sends, 0) as deferred_ratio,
            aggregates.drops / nullif(aggregates.sends, 0) as dropped_ratio,
            aggregates.bounces / nullif(aggregates.sends, 0) as bounced_ratio,
            aggregates.conversions / nullif(aggregates.sends, 0) as conversions_ratio,
            aggregates.net_subscribes / nullif(aggregates.sends, 0) as subscribes_ratio
            -----

    from campaigns
    left join aggregates on campaigns.email_campaign_id = aggregates.email_campaign_id ---one-to-one
)

select * from final
