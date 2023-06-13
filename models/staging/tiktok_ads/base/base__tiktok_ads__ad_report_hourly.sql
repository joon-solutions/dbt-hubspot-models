{{ config(enabled=var('ad_reporting__tiktok_ads_enabled', False)) }}

with base as (

    select *
    from {{ source('tiktok_ads', 'ad_report_hourly') }}

),

final as (

    select
        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('tiktok_ads', 'ad_report_hourly')),
                staging_columns=get_tiktok_ads_report_hourly_columns()
            )
        }}

    from base

)


select
    *,
    {{ dbt_utils.surrogate_key(['ad_id','stat_time_hour']) }} as unique_id
from final
