{{ config(enabled=var('marketo__campaign', True)) }}

with base as (

    select *
    from {{ source('marketo', 'campaign') }}

),

macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('marketo', 'campaign')),
                staging_columns=get_marketo_campaign_columns()
            )
        }}
    from base

),

fields as (

    select
        is_active,
        to_timestamp(created_timestamp, 'YYYY-MM-DD HH24:MI:SS TZD') as created_timestamp,
        description,
        campaign_id, --PK?
        campaign_name,
        program_id,
        program_name,
        campaign_type,
        to_timestamp(updated_timestamp, 'YYYY-MM-DD HH24:MI:SS TZD') as updated_timestamp,
        workspace_name
    from macro

)

select *
from fields
