{{ config(enabled=var('ad_reporting__twitter_ads_enabled')) }}

with source as (

    select * from {{ source('twitter_ads', 'tweet_url') }}

),

renamed as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('twitter_ads', 'tweet_url')),
                staging_columns=get_tweet_url_columns()
            )
        }}


    from source

)

select
*,
        {{ dbt_utils.split_part('expanded_url', "'?'", 1) }} as base_url,
        {{ dbt_utils.get_url_host('expanded_url') }} as url_host,
        '/' || {{ dbt_utils.get_url_path('expanded_url') }} as url_path,
        {{ dbt_utils.get_url_parameter('expanded_url', 'utm_source') }} as utm_source,
        {{ dbt_utils.get_url_parameter('expanded_url', 'utm_medium') }} as utm_medium,
        {{ dbt_utils.get_url_parameter('expanded_url', 'utm_campaign') }} as utm_campaign,
        {{ dbt_utils.get_url_parameter('expanded_url', 'utm_content') }} as utm_content,
        {{ dbt_utils.get_url_parameter('expanded_url', 'utm_term') }} as utm_term,
        {{ dbt_utils.surrogate_key(['tweet_id','index']) }} as unique_id
from renamed
