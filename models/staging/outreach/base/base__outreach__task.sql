
{{ config(enabled = var('outreach_task') ) }}

with source as (

    select * from {{ source('outreach', 'task') }}

),

renamed as (

    select

        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('outreach', 'task')),
                staging_columns = get_staging_outreach_task_columns()
            )
        }}

    from source

)

select *
from renamed
