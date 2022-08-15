{{ config(enabled=var('ad_reporting__linkedin_ads_enabled')) }}
with source as (

    select * from {{ source('linkedin_ads', 'campaign_group_history') }}

),

renamed as (

    select
        id as campaign_group_id,
        cast(last_modified_time as {{ dbt_utils.type_timestamp() }}) as last_modified_at,
        account_id,
        cast(created_time as {{ dbt_utils.type_timestamp() }}) as created_at,
        name as campaign_group_name,
        case
            when row_number() over (partition by campaign_group_id order by last_modified_at) = 1 then created_at
            else last_modified_at
            end as valid_from,
        lead(last_modified_at) over (partition by campaign_group_id order by last_modified_at) as valid_to,
        {{ dbt_utils.surrogate_key(['campaign_group_id','last_modified_at']) }} as campaign_group_version_id

    from source

)

select * from renamed
