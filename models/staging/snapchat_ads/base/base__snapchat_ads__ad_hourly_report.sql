{{ config(enabled=var('ad_reporting__snapchat_ads_enabled')) }}
with source as (

    select * from {{ source('snapchat_ads', 'ad_hourly_report') }}

),

renamed as (

    select
        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('snapchat_ads', 'ad_hourly_report')),
                staging_columns=get_snapchat_ads_ad_hourly_report_columns()
            )
        }}
    from source

)

select
    ad_id,
    date_hour,
    impressions,
    swipes,
    (spend / 1000000.0) as spend,
    {{ dbt_utils.surrogate_key(['ad_id','date_hour']) }} as unique_id
from renamed
