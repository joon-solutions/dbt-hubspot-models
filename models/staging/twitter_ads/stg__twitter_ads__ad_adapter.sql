{{ config(enabled=var('ad_reporting__twitter_ads_enabled')) }}
with accounts as (

    select *
    from {{ ref('base__twitter_ads__account_history') }}
    where is_latest_version = True

),

campaigns as (

    select *
    from {{ ref('base__twitter_ads__campaign_history') }}
    where is_latest_version = True

),

line_items as (

    select *
    from {{ ref('base__twitter_ads__line_item_history') }}
    where is_latest_version = True

),

metrics as (

    select *
    from {{ ref('base__twitter_ads__promoted_tweet_report') }}

),

promoted_tweet as (

    select *
    from {{ ref('base__twitter_ads__promoted_tweet_history')}}
    where is_latest_version = True

),

tweet_url as (

    select *
    from {{ ref('base__twitter_ads__tweet_url') }}

),

joined as (

    select
        metrics.date_day,
        tweet_url.base_url,
        tweet_url.url_host,
        tweet_url.url_path,
        tweet_url.utm_source,
        tweet_url.utm_medium,
        tweet_url.utm_campaign,
        tweet_url.utm_content,
        tweet_url.utm_term,
        line_items.name as line_item_name,
        line_items.line_item_id,
        campaigns.campaign_name,
        campaigns.campaign_id,
        sum(metrics.spend) as spend,
        sum(metrics.clicks) as clicks,
        sum(metrics.url_clicks) as url_clicks,
        sum(metrics.impressions) as impressions
    from metrics
    left join promoted_tweet
        on metrics.promoted_tweet_id = promoted_tweet.promoted_tweet_id --many-to-one
    left join tweet_url
        on promoted_tweet.tweet_id = tweet_url.tweet_id --many-to-many
    left join line_items
        on promoted_tweet.line_item_id = line_items.line_item_id --many-to-many
    left join campaigns
        on line_items.campaign_id = campaigns.campaign_id --many-to-many
    {{ dbt_utils.group_by(13) }}

),

unique_id as (

    select
        *,
        {{ dbt_utils.surrogate_key(['date_day','base_url','line_item_id','campaign_id']) }} as daily_ad_id
    from joined

)

select *
from unique_id
