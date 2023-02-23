--To disable this model, set the below variable within your dbt_project.yml file to False.
{{ config(enabled=var('salesforce__lead_enabled', True)) }}

with source as (

    select *
    from {{ source('salesforce', 'lead') }}

),

renamed as (

    select

    {{
        fivetran_utils.fill_staging_columns(
            source_columns=adapter.get_columns_in_relation(source('salesforce', 'lead')),
            staging_columns = get_salesforce_lead_columns()
        )
    }}

    from source
),

final as (
    select
        lead_id,
        account_id,
        contact_id,
        --
        lead_name,
        lead_mobile_phone,
        lead_phone,
        lead_email,
        --
        company,
        title,
        website,
        --
        country,
        state,
        city,
        street,
        ---source
        lead_source,
        utm_medium,
        utm_source,
        utm_campaign,
        ---
        is_deleted,
        cast(created_at as {{ dbt_utils.type_timestamp() }}) as created_at,
        cast(_fivetran_synced as {{ dbt_utils.type_timestamp() }}) as _fivetran_synced

    from renamed
    where not coalesce(is_deleted, false)
)

select *
from final
