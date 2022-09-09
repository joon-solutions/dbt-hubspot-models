{{ config(enabled=var('ad_reporting__tiktok_ads_enabled')) }}

with base as (

    select *
    from {{ ref('stg__tiktok_ads__ad_adapter') }}

),

fields as (

    select
        unique_id,
        advertiser_name as account_name,
        advertiser_id as account_id,
        date_day,
        base_url,
        url_host,
        url_path,
        utm_source,
        utm_medium,
        utm_campaign,
        utm_content,
        utm_term,
        campaign_id,
        campaign_name,
        ad_group_id,
        ad_group_name as ad_group_name,
        'TikTok Ads' as platform,
        sum(coalesce(clicks, 0)) as clicks,
        sum(coalesce(impressions, 0)) as impressions,
        sum(coalesce(spend, 0)) as spend

    from base
    {{ dbt_utils.group_by(16) }}


)

select *
from fields
