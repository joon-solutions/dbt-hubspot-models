{{ config(enabled=var('marketo__activity_change_data_value')) }}

with base as (

    select *
    from {{ source('marketo', 'activity_change_data_value') }}

),

macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('marketo', 'activity_change_data_value')),
                staging_columns=get_marketo_activity_change_data_value_columns()
            )
        }}
    from base

),

fields as (

    select
        cast(activity_date as {{ dbt_utils.type_timestamp() }}) as activity_timestamp,
        activity_type_id,
        api_method_name,
        campaign_id,
        activity_id,
        lead_id,
        modifying_user_id,
        new_value,
        old_value,
        primary_attribute_value,
        primary_attribute_value_id,
        change_reason,
        request_id,
        change_source
    from macro

)

select *
from fields
