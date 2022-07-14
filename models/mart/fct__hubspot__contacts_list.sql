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

    select distinct
                contact_list_id,
                contact_list_name,
                contact_email,
                contact_id
    from {{ ref('stg__hubspot__contacts_joins') }}
    where contact_list_id is not null

),

events_aggregates as (
    select
            events.recipient,
            ---subscribe event
            subscriptions.is_subscriber,
            sum(subscriptions.count_subscribe_events) as subscribes,
            sum(subscriptions.count_unsubscribe_events) as unsubscribes,
            sum(subscriptions.net_subscription_events) as net_subscribes,
            ----
            {% for metric in var('email_metrics') %}
            sum(events.{{ metric }}) as {{ metric }}{% if not loop.last %},{% endif %}
            {% endfor %}

    from events
    left join subscriptions on events.email_send_id = subscriptions.caused_by_event_id  --one-to-one
    group by 1, 2
),

aggregates as (

    select
            ---contact attributes\
            contact.contact_list_id,
            contact.contact_list_name,
            ---conversion event
            coalesce(sum(conversions.conversions), 0) as conversions,
            coalesce(count(distinct case when conversions.contact_id is not null then contact.contact_id end), 0) as total_recip_conversions,
            ---subscribe event
            coalesce(sum(events_aggregates.subscribes), 0) as subscribes,
            coalesce(sum(events_aggregates.unsubscribes), 0) as unsubscribes,
            coalesce(sum(events_aggregates.net_subscribes), 0) as net_subscribes,
            coalesce(count(distinct case when events_aggregates.is_subscriber then events_aggregates.recipient end), 0) as total_recip_subscribes,
            ----
            {% for metric in var('email_metrics') %}
            coalesce(sum(events_aggregates.{{ metric }}), 0) as {{ metric }},
            coalesce(count(distinct case when events_aggregates.{{ metric }} > 0 then events_aggregates.recipient end), 0) as total_recip_{{ metric }}{% if not loop.last %},{% endif %}
            {% endfor %}

    from contact
    left join conversions on contact.contact_id = conversions.contact_id ---many-to-one
    left join events_aggregates on contact.contact_email = events_aggregates.recipient ---one_to_one
    group by 1, 2

),

final as (
    select
            ---campaign attributes
            contact_list_id,
            contact_list_name,
            ----total events by event type
            opens,
            sends,
            deliveries,
            drops,
            clicks,
            forwards,
            deferrals,
            bounces,
            spam_reports,
            prints,
            conversions,
            subscribes,
            unsubscribes,
            net_subscribes,
            ----total recipients by event type 
           total_recip_opens,
           total_recip_sends,
           total_recip_deliveries,
           total_recip_drops,
           total_recip_clicks,
           total_recip_forwards,
           total_recip_deferrals,
           total_recip_bounces,
           total_recip_spam_reports,
           total_recip_prints,
           total_recip_conversions,
           total_recip_subscribes,
            ---- booleans
            conversions > 0 as was_converted,
            bounces + drops + deferrals as undeliveries,
            bounces > 0 as was_bounced,
            clicks > 0 as was_clicked,
            deferrals > 0 as was_deferred,
            deliveries > 0 as was_delivered,
            forwards > 0 as was_forwarded,
            opens > 0 as was_opened,
            prints > 0 as was_printed,
            spam_reports > 0 as was_spam_reported,
            net_subscribes > 0 as was_subscribed,
            ---ratio by event type
            opens / nullif(sends, 0) as open_ratio,
            clicks / nullif(sends, 0) as click_ratio,
            deliveries / nullif(sends, 0) as delivered_ratio,
            deferrals / nullif(sends, 0) as deferred_ratio,
            drops / nullif(sends, 0) as dropped_ratio,
            bounces / nullif(sends, 0) as bounced_ratio,
            conversions / nullif(sends, 0) as conversions_ratio,
            net_subscribes / nullif(sends, 0) as subscribes_ratio,
            -----
            total_recip_opens / nullif(total_recip_sends, 0) as unique_open_ratio,
            total_recip_clicks / nullif(total_recip_sends, 0) as unique_click_ratio,
            total_recip_deliveries / nullif(total_recip_sends, 0) as unique_delivered_ratio,
            total_recip_deferrals / nullif(total_recip_sends, 0) as unique_deferred_ratio,
            total_recip_drops / nullif(total_recip_sends, 0) as unique_dropped_ratio,
            total_recip_bounces / nullif(total_recip_sends, 0) as unique_bounced_ratio,
            total_recip_conversions / nullif(total_recip_sends, 0) as unique_conversions_ratio,
            total_recip_subscribes / nullif(total_recip_sends, 0) as unique_subscribes_ratio

    from aggregates
)

select * from final

