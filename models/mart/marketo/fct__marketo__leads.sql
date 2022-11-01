with leads as (

    select *
    from {{ ref('base__marketo__lead') }}

),

email_stats as (

    select *
    from {{ ref('stg__marketo__email_sends') }}

),

joined as (

    select
        leads.lead_id,
        leads.created_timestamp,
        leads.updated_timestamp,
        count(*) as count_sends,
        sum(email_stats.count_opens) as count_opens,
        sum(email_stats.count_bounces) as count_bounces,
        sum(email_stats.count_clicks) as count_clicks,
        sum(email_stats.count_deliveries) as count_deliveries,
        sum(email_stats.count_unsubscribes) as count_unsubscribes,
        count(distinct case when email_stats.was_opened = True then email_stats.email_send_id end) as count_unique_opens,
        count(distinct case when email_stats.was_clicked = True then email_stats.email_send_id end) as count_unique_clicks
    from leads
    left join email_stats
        on leads.lead_id = email_stats.lead_id
    group by 1, 2, 3

)

select *
from joined
