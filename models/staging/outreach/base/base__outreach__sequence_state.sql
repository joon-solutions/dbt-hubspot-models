
{{ config(enabled = var('outreach_sequence_state') ) }}

with source as (

    select * from {{ source('outreach', 'sequence_state') }}

),

renamed as (

    select

        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('outreach', 'sequence_state')),
                staging_columns = get_staging_outreach_sequence_state_columns()
            )
        }}

    from source

)

select
    *
from renamed
