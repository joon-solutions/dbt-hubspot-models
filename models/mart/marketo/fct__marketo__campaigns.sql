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
        sum(email_sends.count_opens) as count_opens,
        sum(email_sends.count_bounces) as count_bounces,
        sum(email_sends.count_clicks) as count_clicks,
        sum(email_sends.count_deliveries) as count_deliveries,
        sum(email_sends.count_unsubscribes) as count_unsubscribes,
        count(distinct case when email_sends.was_opened = True then email_sends.email_send_id end) as count_unique_opens,
        count(distinct case when email_sends.was_clicked = True then email_sends.email_send_id end) as count_unique_clicks
    from campaigns
    left join email_sends on campaigns.campaign_id = email_sends.campaign_id --one-to-many
    {{ dbt_utils.group_by(10) }}
    
)

select *
from final