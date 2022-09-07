{{ config(enabled=var('ad_reporting__linkedin_ads_enabled')) }}
with source as (

    select * from {{ source('linkedin_ads', 'account_history') }}

),

renamed as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('linkedin_ads', 'account_history')),
                staging_columns=get_linkedin_ads_account_history_columns()
            )
        }}
    from source
),

final as (

    select
        *,
        {{ dbt_utils.surrogate_key(['account_id','version_tag']) }} as account_version_id,
        case
            when row_number() over (partition by account_id order by version_tag) = 1 then created_at
            else last_modified_at
        end as valid_from,
        lead(last_modified_at) over (partition by account_id order by version_tag) as valid_to
    from renamed

)

select *
from final
