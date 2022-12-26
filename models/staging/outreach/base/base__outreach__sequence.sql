
{{ config(enabled = var('outreach_sequence') ) }}

with source as (

    select * from {{ source('outreach', 'sequence') }}

),

renamed as (

    select

        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('outreach', 'sequence')),
                staging_columns = get_staging_outreach_sequence_columns()
            )
        }}

    from source

)

select
    *
from renamed
