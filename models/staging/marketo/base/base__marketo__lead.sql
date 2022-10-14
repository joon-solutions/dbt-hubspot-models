{{ config(enabled=var('marketo__lead', True)) }}

with base as (

    select *
    from {{ source('marketo', 'lead') }}

),

macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('marketo', 'lead')),
                staging_columns=get_marketo_lead_columns()
            )
        }}
    from base
)

select *
from macro
