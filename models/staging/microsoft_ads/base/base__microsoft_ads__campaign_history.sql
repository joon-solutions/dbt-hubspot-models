{{ config(enabled=var('ad_reporting__microsoft_ads_enabled', False)) }}
with source as (

    select * from {{ source('microsoft_ads', 'campaign_history') }}

),

renamed as (

    select
        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('microsoft_ads', 'campaign_history')),
                staging_columns = get_microsoft_ads_campaign_history_columns()
            )
        }}
        -- id as campaign_id,
        -- account_id,
        -- name as campaign_name,
        -- modified_time as modified_timestamp,

    from source

)

select
    *,
    {{ dbt_utils.surrogate_key(['campaign_id','modified_timestamp']) }} as campaign_version_id,
    row_number() over (partition by campaign_id order by modified_timestamp desc) = 1 as is_most_recent_version
from renamed
