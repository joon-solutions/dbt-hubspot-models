{{ config(enabled=fivetran_utils.enabled_vars(['contact_form_submission_enabled','contact_list_member_enabled','contact_list_enabled','contact_enabled','email_campaign_enabled','email_event_enabled','email_subscription_change_enabled','email_subscription_enabled'])) }}

with events as (

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
        contact_email,
        contact_name,
        contact_address,
        contact_city,
        contact_country,
        analytics_source,
        contact_job_title,
        contact_company,
        contact_phone,
        created_at
    from {{ ref('int__hubspot__contacts_joins') }}

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
        contact.*,
        coalesce(events_aggregates.is_subscriber, 0) as is_subscriber,
        coalesce(events_aggregates.opens, 0) as opens,
        coalesce(events_aggregates.sends, 0) as sends,
        coalesce(events_aggregates.deliveries, 0) as deliveries,
        coalesce(events_aggregates.drops, 0) as drops,
        coalesce(events_aggregates.clicks, 0) as clicks,
        coalesce(events_aggregates.forwards, 0) as forwards,
        coalesce(events_aggregates.deferrals, 0) as deferrals,
        coalesce(events_aggregates.bounces, 0) as bounces,
        coalesce(events_aggregates.spam_reports, 0) as spam_reports,
        coalesce(events_aggregates.prints, 0) as prints,
        coalesce(conversions.conversions, 0) as conversions,
        coalesce(events_aggregates.subscribes, 0) as subscribes,
        coalesce(events_aggregates.unsubscribes, 0) as unsubscribes,
        coalesce(events_aggregates.net_subscribes, 0) as net_subscribes

    from contact
    left join conversions on contact.contact_id = conversions.contact_id ---one-to-one
    left join events_aggregates on contact.contact_email = events_aggregates.recipient ---one_to_one 


),

final as (

    select
        *,
        ---- booleans
        bounces + drops + deferrals as undeliveries,
        sends > 0 as was_sent,
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
        div0(net_subscribes, sends) as subscribes_ratio
    from aggregates


)

select * from final
