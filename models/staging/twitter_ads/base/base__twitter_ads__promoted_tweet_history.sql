{{ config(enabled=var('ad_reporting__twitter_ads_enabled')) }}

with source as (

    select * from {{ source('twitter_ads', 'promoted_tweet_history') }}

),

renamed as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('twitter_ads', 'promoted_tweet_history')),
                staging_columns=get_promoted_tweet_history_columns()
            )
        }}

    from source

)

select *,
        row_number() over (partition by promoted_tweet_id order by updated_timestamp asc) = 1 as is_latest_version 
from renamed