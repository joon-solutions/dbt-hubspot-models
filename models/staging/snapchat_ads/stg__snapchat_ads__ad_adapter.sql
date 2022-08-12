with report as (

    select *
    from {{ ref('base__snapchat_ads__ad_hourly_report') }}

), creatives as (

    select *
    from {{ ref('stg__snapchat_ads__creative_history_prep') }}

), accounts as (

    select *
    from {{ ref('base__snapchat_ads__ad_account_history') }}
    where is_most_recent_record = true

), ads as (

    select *
    from {{ ref('base__snapchat_ads__ad_history') }}
    where is_most_recent_record = true

), ad_squads as (

    select *
    from {{ ref('base__snapchat_ads__ad_squad_history') }}
    where is_most_recent_record = true

), campaigns as (

    select *
    from {{ ref('base__snapchat_ads__campaign_history') }}
    where is_most_recent_record = true

), joined as (

    select
        report.unique_id,
        cast(report.date_hour as date) as date_day,
        accounts.ad_account_id,
        accounts.ad_account_name,
        campaigns.campaign_id,
        campaigns.campaign_name,
        ad_squads.ad_squad_id,
        ad_squads.ad_squad_name,
        ads.ad_id,
        ads.ad_name,
        creatives.base_url,
        creatives.url_host,
        creatives.url_path,
        creatives.utm_source,
        creatives.utm_medium,
        creatives.utm_campaign,
        creatives.utm_content,
        creatives.utm_term,
        sum(report.spend) as spend,
        sum(report.impressions) as impressions,
        sum(report.swipes) as swipes
    from report
    left join ads 
        on report.ad_id = ads.ad_id --many-to-one
    left join creatives
        on ads.creative_id = creatives.creative_id --many-to-one
    left join ad_squads
        on ads.ad_squad_id = ad_squads.ad_squad_id--many-to-one
    left join campaigns
        on ad_squads.campaign_id = campaigns.campaign_id--many-to-one
    left join accounts
        on campaigns.ad_account_id = accounts.ad_account_id--many-to-one
    {{ dbt_utils.group_by(18) }}


)

select *
from joined 