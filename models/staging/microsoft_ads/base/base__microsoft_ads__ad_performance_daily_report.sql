{{ config(enabled=var('ad_reporting__microsoft_ads_enabled')) }}
with source as (

    select * from {{ source('microsoft_ads', 'ad_performance_daily_report') }}

),

renamed as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('microsoft_ads', 'ad_performance_daily_report')),
                staging_columns = get_microsoft_ads_ad_performance_daily_report_columns()
            )
        }}
        -- date as date_day,
        -- account_id,
        -- campaign_id,
        -- ad_group_id,
        -- ad_id,
        -- currency_code,
        -- clicks,
        -- impressions,
        -- spend,
        

    from source

)

select 
        cast(date_day as date) as date_day,
        account_id,
        campaign_id,
        ad_group_id,
        ad_id,
        currency_code,
        clicks,
        impressions,
        spend,
        {{ dbt_utils.surrogate_key(['account_id','campaign_id','ad_group_id','ad_id','date_day','currency_code','ad_distribution','device_type','language','network','device_os','top_vs_other','bid_match_type','delivered_match_type']) }} as unique_id
from renamed
