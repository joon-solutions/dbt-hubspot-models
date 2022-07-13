with subscription_change as (
    select
        caused_by_event_id,
        recipient,
        email_subscription_id,
        change,
        last_value(change) over (partition by email_subscription_id, recipient order by created_at asc) = 'SUBSCRIBED' as is_subscriber
    from {{ ref('base__hubspot__email_subscription_change') }}
),

subscription as (
    select *
    from {{ ref('base__hubspot__email_subscription') }}
),


aggregates as (
    select
        {{ dbt_utils.surrogate_key(['subscription_change.caused_by_event_id','subscription_change.recipient']) }} as id,
        subscription_change.caused_by_event_id,
        subscription.subscription_name,
        subscription_change.recipient,
        subscription_change.is_subscriber,
        count(case when subscription_change.change = 'SUBSCRIBED' then subscription_change.email_subscription_id end) as count_subscribe_events,
        count(case when subscription_change.change = 'UNSUBSCRIBED' then subscription_change.email_subscription_id end) as count_unsubscribe_events,
        count(case when subscription_change.change = 'REPORTED_SPAM' then subscription_change.email_subscription_id end) as count_spam_report_events,
        count_subscribe_events - count_unsubscribe_events as net_subscription_events
    from subscription_change
    left join subscription on subscription_change.email_subscription_id = subscription.email_subscription_id ---many-to-one
    {{ dbt_utils.group_by(5) }}
)

select * from aggregates
