with source as (

    select * from {{ source('linkedin_ads', 'campaign_history') }}

),

renamed as (

    select
        id as campaign_id,
        cast(last_modified_time as {{ dbt_utils.type_timestamp() }}) as last_modified_at,
        account_id,
        campaign_group_id,
        cast(created_time as {{ dbt_utils.type_timestamp() }}) as created_at,
        name as campaign_name,
        cast(version_tag as numeric) as version_tag,
        case 
            when row_number() over (partition by campaign_id order by version_tag) = 1 then created_at
            else last_modified_at
            end as valid_from,
        lead(last_modified_at) over (partition by campaign_id order by version_tag) as valid_to,
        {{ dbt_utils.surrogate_key(['campaign_id','version_tag']) }} as campaign_version_id

    from source

)

select * from renamed