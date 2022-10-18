{{ config(enabled=var('marketo__program', True)) }}

with base as (

    select *
    from {{ source('marketo', 'program') }}

),

macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('marketo', 'program')),
                staging_columns=get_marketo_program_columns()
            )
        }}
    from base

),

fields as (

    select
        program_id,
        channel,
        created_timestamp,
        description,
        end_timestamp,
        program_name,
        sfdc_id,
        sfdc_name,
        start_timestamp,
        program_status,
        program_type,
        updated_timestamp,
        url,
        workspace
    from macro

)

select *
from fields
