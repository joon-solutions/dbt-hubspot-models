{{ config(enabled=var('ad_reporting__twitter_ads_enabled')) }}
with source as (

    select * from {{ source('twitter_ads', 'promoted_tweet_report') }}

),

renamed as (

    select
    
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('twitter_ads', 'promoted_tweet_report')),
                staging_columns=get_twitter_ads_promoted_tweet_report_columns()
            )
        }}

    from source
),

final as (

    select
        *,
        cast(date as date) as date_day,
        round(billed_charge_local_micro / 1000000.0, 2) as spend,
        {{ dbt_utils.surrogate_key(['account_id','promoted_tweet_id','date_day']) }} as unique_id
    from renamed
)

select * from final
