{{ config(enabled=var('ad_reporting__twitter_ads_enabled')) }}

with source as (

    select * from {{ source('twitter_ads', 'promoted_tweet_report') }}

),

renamed as (

    select
    _fivetran_synced,
    account_id,
    round(billed_charge_local_micro / 1000000.0,2) as spend,
    clicks,
    cast(date as date) as date_day,
    impressions,
    promoted_tweet_id,
    url_clicks,
    {{ dbt_utils.surrogate_key(['account_id','promoted_tweet_id','date_day']) }} as unique_id
    from source

)

select *
        
from renamed