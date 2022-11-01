{{ config(enabled=var('marketo__activity_delete_lead_enabled', True)) }}

with base as (

    select *
    from {{ source('marketo', 'activity_delete_lead') }}

),

macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('marketo', 'activity_delete_lead')),
                staging_columns=get_marketo_activity_delete_lead_columns()
            )
        }}
    from base

),

fields as (

    select
        activity_id,
        _fivetran_synced,
        cast(activity_date as {{ dbt_utils.type_timestamp() }}) as activity_timestamp,
        activity_type_id,
        campaign_name,
        campaign_id,
        lead_id,
        primary_attribute_value,
        primary_attribute_value_id
    from macro

)

select *
from fields