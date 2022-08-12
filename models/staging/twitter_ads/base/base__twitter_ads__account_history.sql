{{ config(enabled=var('ad_reporting__twitter_ads_enabled')) }}

with source as (

    select * from {{ source('twitter_ads', 'account_history') }}

),

renamed as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('twitter_ads', 'account_history')),
                staging_columns=get_account_history_columns()
            )
        }}
        -- _fivetran_synced,
        -- approval_status,
        -- business_id,
        -- business_name,
        -- created_at,
        -- deleted,
        -- id,
        -- industry_type,
        -- name,
        -- salt,
        -- timezone,
        -- timezone_switch_at,
        -- updated_at,
    from source
        

)

select  *,
        row_number() over (partition by account_id order by updated_timestamp asc) = 1 as is_latest_version,
        {{ dbt_utils.surrogate_key(['account_id','updated_timestamp']) }} as unique_id
from renamed