{{ config(enabled=var('ad_reporting__linkedin_ads_enabled')) }}
with source as (

    select * from {{ source('linkedin_ads', 'account_history') }}

),

renamed as (

    select
        id as account_id,
        cast(last_modified_time as {{ dbt_utils.type_timestamp() }}) as last_modified_at,
        cast(created_time as {{ dbt_utils.type_timestamp() }}) as created_at,
        name as account_name,
        currency,
        cast(version_tag as numeric) as version_tag

    from source

),

valid_dates as (

    select
        *,
        case
            when row_number() over (partition by account_id order by version_tag) = 1 then created_at
            else last_modified_at
        end as valid_from,
        lead(last_modified_at) over (partition by account_id order by version_tag) as valid_to
    from renamed

),

surrogate_key as (

    select
        *,
        {{ dbt_utils.surrogate_key(['account_id','version_tag']) }} as account_version_id
    from valid_dates

)

select *
from surrogate_key
