{{ config(enabled=var('ad_reporting__google_ads_enabled', False)) }}

with base as (

    select *
    from {{ ref('stg__google_ads__url_ad_adapter') }}

),

fields as (

    select
        unique_id,
        'Google Ads' as platform,
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
