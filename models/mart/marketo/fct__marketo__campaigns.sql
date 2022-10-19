{{ config(enabled=var('marketo__campaign', True)) }}

with campaigns as (

    select *
    from {{ ref('base__marketo__campaign') }}

),

email_sends as (

    select *
    from {{ ref('stg__marketo__email_sends') }}

),

final as ( --PK=campaign_id
    select
        campaigns.*,
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
    {{ dbt_utils.group_by(10) }}

)

select *
from final
