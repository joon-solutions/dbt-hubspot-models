{{ config(enabled=var('marketo__activity_merge_leads', True)) }}

with base as (

    select *
    from {{ source('marketo', 'activity_merge_leads') }}

),

macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('marketo', 'activity_merge_leads')),
                staging_columns=get_marketo_activity_merge_leads_columns()
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
        campaign_id,
        cast(lead_id as {{ dbt_utils.type_int() }}) as lead_id,
        master_updated,
        cast(replace(trim(trim(merge_ids, ']'), '['), ',', ', ') as {{ dbt_utils.type_string() }}) as merged_lead_id,
        merge_source,
        merged_in_sales,
        primary_attribute_value,
        primary_attribute_value_id
    from macro

)

select *
from fields