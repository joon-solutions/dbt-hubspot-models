with stats as (

    select *
    from {{ ref('base__google_ads__ad_stats') }}

), accounts as (

    select *
    from {{ ref('base__google_ads__account_history') }}
    where is_most_recent_record = True
    
), campaigns as (

    select *
    from {{ ref('base__google_ads__campaign_history') }}
    where is_most_recent_record = True
    
), ad_groups as (

    select *
    from {{ ref('base__google_ads__ad_group_history') }}
    where is_most_recent_record = True
    
), ads as (

    select *
    from {{ ref('base__google_ads__ad_history') }}
    where is_most_recent_record = True
    
), fields as (
    select
        stats.unique_id,
        stats.date_day,
        accounts.account_name,
        accounts.account_id,
        campaigns.campaign_name,
        campaigns.campaign_id,
        ad_groups.ad_group_name,
        ad_groups.ad_group_id,
        ads.base_url,
        ads.url_host,
        ads.url_path,
        ads.utm_source,
        ads.utm_medium,
        ads.utm_campaign,
        ads.utm_content,
        ads.utm_term,
        sum(stats.spend) as spend,
        sum(stats.clicks) as clicks,
        sum(stats.impressions) as impressions

    from stats
    left join ads
        on stats.ad_id = ads.ad_id ---many-to-one
    left join ad_groups
        on ads.ad_group_id = ad_groups.ad_group_id --many-to-one
    left join campaigns
        on ad_groups.campaign_id = campaigns.campaign_id --many-to-one
    left join accounts
        on campaigns.account_id = accounts.account_id --many-to-one
    {{ dbt_utils.group_by(16) }}

)

select *
from fields