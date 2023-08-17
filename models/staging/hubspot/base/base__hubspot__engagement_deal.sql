{{ config(enabled = var('hubspot__engagement_deal', False) ) }}

with base as (

    select *
    from {{ source(var('hubspot_schema', 'hubspot'),'engagement_deal') }}

),

macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source(var('hubspot_schema', 'hubspot'),'engagement_deal')),
                staging_columns=get_hubspot_engagement_deal_columns()
            )
        }}
    from base

),

fields as (

    select
        _fivetran_synced,
        deal_id,
        engagement_id,
        {{ dbt_utils.surrogate_key(['deal_id','engagement_id']) }} as engagement_deal_id
    from macro

)

select *
from fields
