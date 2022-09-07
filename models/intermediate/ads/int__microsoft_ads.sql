{{ config(enabled=var('ad_reporting__microsoft_ads_enabled')) }}

with base as (

    select *
    from {{ ref('stg__microsoft_ads__ad_adapter') }}

),

fields as (

    select
        unique_id,
        'Microsoft Ads' as platform,
        date_day,
        account_name,
        account_id,
        campaign_name,
        campaign_id,
        ad_group_name,
        ad_group_id,
        base_url,
        url_host,
        url_path,
        utm_source,
        utm_medium,
        utm_campaign,
        utm_content,
        utm_term,
        coalesce(clicks, 0) as clicks,
        coalesce(impressions, 0) as impressions,
        coalesce(spend, 0) as spend
    from base


)

select *
from fields
