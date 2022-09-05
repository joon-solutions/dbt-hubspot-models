{{ config(enabled = var('email_subscription_change_enabled') ) }}

with subscription_change as (
    select
        caused_by_event_id,
        recipient,
        email_subscription_id,
        change,
        last_value(change) over (partition by email_subscription_id, recipient order by created_at asc) = 'SUBSCRIBED' as is_subscriber
    from {{ ref('base__hubspot__email_subscription_change') }}
),

aggregates as (
    select
        caused_by_event_id,
        recipient,
        -- subscription.subscription_name,
        max(is_subscriber) as is_subscriber, --max(true,false,false) = true (only need at least 1 true record)
        count(case when change = 'SUBSCRIBED' then email_subscription_id end) as count_subscribe_events,
        count(case when change = 'UNSUBSCRIBED' then email_subscription_id end) as count_unsubscribe_events,
        count_subscribe_events - count_unsubscribe_events as net_subscription_events
    from subscription_change
    -- left join subscription on email_subscription_id = subscription.email_subscription_id ---many-to-one
    {{ dbt_utils.group_by(2) }}
)

select * from aggregates
