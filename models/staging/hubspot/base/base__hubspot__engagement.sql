{{ config(enabled = var('hubspot__engagement') ) }}

with base as (

    select *
    from {{ source('hubspot','engagement') }}

),

macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('hubspot','engagement')),
                staging_columns=get_hubspot_engagement_columns()
            )
        }}
    from base

),

fields as (

    select
        _fivetran_synced,
        is_active,
        activity_type,
        created_timestamp,
        engagement_id,
        last_updated_timestamp,
        owner_id,
        portal_id,
        occurred_timestamp,
        engagement_type
    from macro

)

select *
from fields
