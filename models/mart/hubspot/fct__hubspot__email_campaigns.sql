{{ config(enabled=fivetran_utils.enabled_vars(['contact_form_submission_enabled','contact_list_member_enabled','contact_list_enabled','contact_enabled','email_campaign_enabled','email_event_enabled','email_subscription_change_enabled','email_subscription_enabled'])) }}

with campaigns as (

    select *
    from {{ ref('base__hubspot__email_campaign') }}

),

events as (

    select *
    from {{ ref('int__hubspot__email_events_aggregates') }}

),

subscriptions as (

    select *
    from {{ ref('int__hubspot__email_subscriptions_aggregates') }}

),

conversions as (

    select *
    from {{ ref('int__hubspot__email_conversions_aggregates') }}

),

contact as (

    select distinct
        contact_id,
        contact_email
    from {{ ref('int__hubspot__contacts_joins') }}

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
        subscriptions.net_subscription_events,
        subscriptions.is_subscriber,
        conversions.conversions / count(*) over (partition by events.recipient) as conversions ---to avoid duplications as conversions is calculated per contact_id
    from events
    left join contact on events.recipient = contact.contact_email ---many_to_one
    left join conversions on contact.contact_id = conversions.contact_id ---one-to-one
    left join subscriptions on events.email_send_id = subscriptions.caused_by_event_id  --one-to-one
),

aggregates as (

    select
        ---campaign attributes
        campaigns.email_campaign_id,
        campaigns.email_campaign_name,
        campaigns.email_campaign_type,
        min(joins.email_send_at) as email_send_at,
        ---conversion event
        coalesce(sum(joins.conversions), 0) as conversions,
        coalesce(count(distinct case when joins.conversions > 0 then joins.recipient end), 0) as total_recip_conversions,
        ---subscribe event
        coalesce(sum(joins.count_subscribe_events), 0) as subscribes,
        coalesce(sum(joins.count_unsubscribe_events), 0) as unsubscribes,
        coalesce(sum(joins.net_subscription_events), 0) as net_subscribes,
        coalesce(count(distinct case when joins.is_subscriber then joins.recipient end), 0) as total_recip_subscribes,
        ----
        {% for metric in var('email_metrics') %}
            coalesce(sum(joins.{{ metric }}), 0) as {{ metric }},
            coalesce(count(distinct case when joins.{{ metric }} > 0 then joins.recipient end), 0) as total_recip_{{ metric }}{% if not loop.last %},{% endif %}
        {% endfor %}
    from campaigns
    left join joins on campaigns.email_campaign_id = joins.email_campaign_id ---one-to-one
    group by 1, 2, 3
),

final as (
    select
        ---campaign attributes
        email_campaign_id,
        email_campaign_name,
        email_campaign_type,
        email_send_at,
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
        total_recip_opens,
        ----total recipients by event type 
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
        bounces + drops + deferrals as undeliveries,
        ---- booleans
        conversions > 0 as was_converted,
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
        div0(opens, sends) as open_ratio,
        div0(clicks, sends) as click_ratio,
        div0(deliveries, sends) as delivered_ratio,
        div0(deferrals, sends) as deferred_ratio,
        div0(drops, sends) as dropped_ratio,
        div0(bounces, sends) as bounced_ratio,
        div0(conversions, sends) as conversions_ratio,
        div0(net_subscribes, sends) as subscribes_ratio,
        div0(total_recip_opens, total_recip_sends) as unique_open_ratio,
        div0(total_recip_clicks, total_recip_sends) as unique_click_ratio,
        div0(total_recip_deliveries, total_recip_sends) as unique_delivered_ratio,
        div0(total_recip_deferrals, total_recip_sends) as unique_deferred_ratio,
        div0(total_recip_drops, total_recip_sends) as unique_dropped_ratio,
        div0(total_recip_bounces, total_recip_sends) as unique_bounced_ratio,
        div0(total_recip_conversions, total_recip_sends) as unique_conversions_ratio,
        div0(total_recip_subscribes, total_recip_sends) as unique_subscribes_ratio

    from aggregates

)

select * from final
