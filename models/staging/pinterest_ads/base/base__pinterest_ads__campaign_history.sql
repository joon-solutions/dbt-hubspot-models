{{ config(enabled=var('ad_reporting__pinterest_enabled')) }}
with source as (

    select * from {{ source('pinterest_ads', 'campaign_history') }}

),

renamed as (

    select
        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('pinterest_ads', 'campaign_history')),
                staging_columns = get_pinterest_ads_campaign_history_columns()
            )
        }}
        -- id as campaign_id,
        -- created_time,
        -- name,
        -- status,
        -- _fivetran_synced,


    from source

)

select
    *,
    {{ dbt_utils.surrogate_key(['campaign_id','_fivetran_synced'] ) }} as version_id,
    row_number() over (partition by campaign_id order by _fivetran_synced desc) as is_latest_version
from renamed
