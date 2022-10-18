{{ config(enabled=var('marketo__lead_describe', True)) }}

with base as (

    select *
    from {{ source('marketo', 'lead_describe') }}

),

macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('marketo', 'lead_describe')),
                staging_columns=get_marketo_lead_describe_columns()
            )
        }}
    from base

),

fields as (

    select
        data_type,
        display_name,
        lead_describe_id,
        field_max_length,
        rest_name,
        is_rest_readonly,
        soap_name,
        is_soap_readonly
    from macro

),

regex as (

    select
        *,
        case
            when rest_name like '%\\_\\_c%' then lower(rest_name)
            else ltrim(lower(regexp_replace(rest_name, '[A-Z]', '_\\0')), '_')
        end as rest_name_xf
    from fields

)

select *
from regex
