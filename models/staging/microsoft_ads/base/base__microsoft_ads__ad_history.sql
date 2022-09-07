{{ config(enabled=var('ad_reporting__microsoft_ads_enabled')) }}
with source as (

    select * from {{ source('microsoft_ads', 'ad_history') }}

),

renamed as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('microsoft_ads', 'ad_history')),
                staging_columns = get_microsoft_ads_ad_history_columns()
            )
        }}
        
        -- id as ad_id,
        -- final_url,
        -- ad_group_id,
        -- modified_time as modified_timestamp,


    from source

)

select 
        *,
        {{ dbt_utils.surrogate_key(['ad_id','modified_timestamp']) }} as ad_version_id,
        row_number() over (partition by ad_id order by modified_timestamp desc) = 1 as is_most_recent_version
from renamed
