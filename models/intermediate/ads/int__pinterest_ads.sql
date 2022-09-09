{{ config(enabled=var('ad_reporting__pinterest_enabled')) }}

with base as (

    select *
    from {{ ref('stg__pinterest_ads__ad_adapter') }}

),

fields as (

    select
        daily_id as unique_id,
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
        ad_group_name,
        platform,
        coalesce(clicks, 0) as clicks,
        coalesce(impressions, 0) as impressions,
        coalesce(spend, 0) as spend
    from base


)

select *
from fields
