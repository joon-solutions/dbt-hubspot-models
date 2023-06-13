{{ config(enabled=var('ad_reporting__facebook_ads_enabled', False) and var('ad_reporting__facebook_ads_basic_ad_enabled', False)) }}

with base as (

    select *
    from {{ ref('stg__facebook_ads__ad_adapter') }}

),

fields as (

    select
        date_day,
        account_name,
        account_id,
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
        ad_set_id as ad_group_id,
        ad_set_name as ad_group_name,
        'Facebook Ads' as platform,
        sum(coalesce(clicks, 0)) as clicks,
        sum(coalesce(impressions, 0)) as impressions,
        sum(coalesce(spend, 0)) as spend
    from base
    {{ dbt_utils.group_by(16) }}


)

select
    *,
    {{ dbt_utils.surrogate_key(['account_id','date_day','ad_group_id','campaign_id']) }} as unique_id
from fields
