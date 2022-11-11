{{ config(enabled = var('hubspot__engagement_contact') ) }}

with base as (

    select *
    from {{ source('hubspot','engagement_contact') }}

),

macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('hubspot','engagement_contact')),
                staging_columns=get_hubspot_engagement_contact_columns()
            )
        }}
    from base

),

fields as (

    select
        _fivetran_synced,
        contact_id,
        engagement_id,
        {{ dbt_utils.surrogate_key(['contact_id','engagement_id']) }} as engagement_contact_id
    from macro

)

select *
from fields
