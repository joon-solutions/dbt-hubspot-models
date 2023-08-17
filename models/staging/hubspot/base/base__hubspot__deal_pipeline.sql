{{ config(enabled = var('hubspot__deal_pipeline', False) ) }}

with source as (

    select * from {{ source(var('hubspot_schema', 'hubspot'), 'deal_pipeline') }}

),

renamed as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source(var('hubspot_schema', 'hubspot'), 'deal_pipeline')),
                staging_columns=get_hubspot_deal_pipeline_columns()
            )
        }}
    from source

)

select *
from renamed
