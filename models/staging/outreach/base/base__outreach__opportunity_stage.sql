{{ config(enabled = var('outreach_opportunity_stage') ) }}

with source as (

    select * from {{ source('outreach', 'opportunity_stage') }}

),

renamed as (

    select

        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('outreach', 'opportunity_stage')),
                staging_columns = get_staging_outreach_opportunity_stage_columns()
            )
        }}

    from source

)

select
    *
from renamed
