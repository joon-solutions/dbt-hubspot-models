{{ config(enabled=var('ad_reporting__linkedin_ads_enabled')) }}
with source as (

    select * from {{ source('linkedin_ads', 'campaign_group_history') }}

),

renamed as (

    select
        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('linkedin_ads', 'campaign_group_history')),
                staging_columns=get_linkedin_ads_campaign_group_history_columns()
            )
        }}
    from source
),

final as (

    select
        *,
        case
            when row_number() over (partition by campaign_group_id order by last_modified_at) = 1 then created_at
            else last_modified_at
        end as valid_from,
        lead(last_modified_at) over (partition by campaign_group_id order by last_modified_at) as valid_to,
        {{ dbt_utils.surrogate_key(['campaign_group_id','last_modified_at']) }} as campaign_group_version_id

    from renamed

)

select * from final
