with sends as (

    select *
    from {{ ref('base__marketo__activity_send_email') }}

),

opens as (
    select
        email_send_id,
        count(*) as count_opens
    from {{ ref('base__marketo__activity_open_email') }}
    group by 1
),

bounces as (
    select
        email_send_id,
        count(*) as count_bounces
    from {{ ref('base__marketo__activity_email_bounced') }}
    group by 1
),

clicks as (
    select
        email_send_id,
        count(*) as count_clicks
    from {{ ref('base__marketo__activity_click_email') }}
    group by 1
),

deliveries as (
    select
        email_send_id,
        count(*) as count_deliveries
    from {{ ref('base__marketo__activity_email_delivered') }}
    group by 1
),

unsubscribes as (
    select
        email_send_id,
        count(*) as count_unsubscribes
    from {{ ref('base__marketo__activity_unsubscribe_email') }}
    group by 1
),

final as (
    select
        sends.*,
        --metrics
        coalesce(opens.count_opens, 0) as count_opens,
        coalesce(bounces.count_bounces, 0) as count_bounces,
        coalesce(clicks.count_clicks, 0) as count_clicks,
        coalesce(deliveries.count_deliveries, 0) as count_deliveries,
        coalesce(unsubscribes.count_unsubscribes, 0) as count_unsubscribes,
        ---boolean
        count_opens > 0 as was_opened,
        count_bounces > 0 as was_bounced,
        count_clicks > 0 as was_clicked,
        count_deliveries > 0 as was_delivered,
        count_unsubscribes > 0 as was_unsubscribed
    from sends
    left join opens on sends.email_send_id = opens.email_send_id
    left join bounces on sends.email_send_id = bounces.email_send_id
    left join clicks on sends.email_send_id = clicks.email_send_id
    left join deliveries on sends.email_send_id = deliveries.email_send_id
    left join unsubscribes on sends.email_send_id = unsubscribes.email_send_id
)

select * from final
