{{ config(enabled=var('ad_reporting__twitter_ads_enabled')) }}

with base as (

    select *
    from {{ ref('stg__twitter_ads__ad_adapter') }}

),

fields as (

    select
        daily_ad_id as unique_id,
        'Twitter Ads' as platform,
        date_day,
        campaign_name,
        cast(campaign_id as {{ dbt_utils.type_string() }}) as campaign_id,
        line_item_name as ad_group_name,
        cast(line_item_id as {{ dbt_utils.type_string() }}) as ad_group_id,
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
