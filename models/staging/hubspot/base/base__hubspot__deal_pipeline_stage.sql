{{ config(enabled = var('hubspot__deal_pipeline_stage') ) }}

with source as (

    select * from {{ source('hubspot', 'deal_pipeline_stage') }}

),

renamed as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('hubspot', 'deal_pipeline_stage')),
                staging_columns=get_hubspot_deal_pipeline_stage_columns()
            )
        }}
    from source

)

select *
from renamed