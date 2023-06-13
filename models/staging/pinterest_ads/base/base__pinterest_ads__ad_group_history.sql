{{ config(enabled=var('ad_reporting__pinterest_enabled', False)) }}
with source as (

    select * from {{ source('pinterest_ads', 'ad_group_history') }}

),

renamed as (
    select

        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('pinterest_ads', 'ad_group_history')),
                staging_columns = get_pinterest_ads_ad_group_history_columns()
            )
        }}

        -- id as ad_group_id,
        -- campaign_id,
        -- created_time,
        -- name,
        -- status,
        -- start_time,
        -- end_time,
        -- _fivetran_synced,

    from source

)

select
    *,
    {{ dbt_utils.surrogate_key(['ad_group_id','_fivetran_synced'] ) }} as version_id,
    row_number() over (partition by ad_group_id order by _fivetran_synced desc) as is_latest_version

from renamed
