{{ config(enabled = var('hubspot__engagement_company') ) }}

with base as (

    select *
    from {{ source('hubspot','engagement_company') }}

),

macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('hubspot','engagement_company')),
                staging_columns=get_hubspot_engagement_company_columns()
            )
        }}
    from base

),

fields as (

    select
        _fivetran_synced,
        company_id,
        engagement_id,
        {{ dbt_utils.surrogate_key(['company_id','engagement_id']) }} as engagement_company_id
    from macro

)

select *
from fields
