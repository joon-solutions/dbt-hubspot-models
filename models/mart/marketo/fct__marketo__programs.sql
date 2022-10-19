{{ config(enabled=var('marketo__program', True)) }}

with programs as ( --PK=program_id

    select *
    from {{ ref('base__marketo__program') }}

),

campaigns as ( --PK=campaign_id
    select *
    from {{ ref('base__marketo__campaign') }}
),

email_sends as (

    select *
    from {{ ref('stg__marketo__email_sends') }}

),

email_sends_agg as ( --PK=email_template_id
    select
        campaigns.program_id,
        count(*) as count_sends,
        coalesce(sum(email_sends.count_opens), 0) as count_opens,
        coalesce(sum(email_sends.count_bounces), 0) as count_bounces,
        coalesce(sum(email_sends.count_clicks), 0) as count_clicks,
        coalesce(sum(email_sends.count_deliveries), 0) as count_deliveries,
        coalesce(sum(email_sends.count_unsubscribes), 0) as count_unsubscribes,
        count(distinct case when email_sends.was_opened = True then email_sends.email_send_id end) as count_unique_opens,
        count(distinct case when email_sends.was_clicked = True then email_sends.email_send_id end) as count_unique_clicks
    from campaigns
    left join email_sends on campaigns.campaign_id = email_sends.campaign_id --one-to-many
    group by 1

),

final as (
    select
        programs.*,
        coalesce(email_sends_agg.count_sends, 0) as count_sends,
        coalesce(email_sends_agg.count_opens, 0) as count_opens,
        coalesce(email_sends_agg.count_bounces, 0) as count_bounces,
        coalesce(email_sends_agg.count_clicks, 0) as count_clicks,
        coalesce(email_sends_agg.count_deliveries, 0) as count_deliveries,
        coalesce(email_sends_agg.count_unsubscribes, 0) as count_unsubscribes,
        coalesce(email_sends_agg.count_unique_opens, 0) as count_unique_opens,
        coalesce(email_sends_agg.count_unique_clicks, 0) as count_unique_clicks
    from programs
    left join email_sends_agg on programs.program_id = email_sends_agg.program_id --one-to-one

)

select *
from final
