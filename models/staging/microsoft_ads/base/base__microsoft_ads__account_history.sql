{{ config(enabled=var('ad_reporting__microsoft_ads_enabled', True)) }}

with source as (

    select * from {{ source('microsoft_ads', 'account_history') }}

),

renamed as (

    select

        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('microsoft_ads', 'account_history')),
                staging_columns = get_microsoft_ads_account_history_columns()
            )
        }}

    -- id as account_id,
    -- name as account_name,
    -- last_modified_time as modified_timestamp,
    from source

)

select
    *,
    {{ dbt_utils.surrogate_key(['account_id','modified_timestamp']) }} as account_version_id,
    row_number() over (partition by account_id order by modified_timestamp desc) = 1 as is_most_recent_version

from renamed
