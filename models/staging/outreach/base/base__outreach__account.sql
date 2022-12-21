
{{ config(enabled = var('outreach_account') ) }}

with source as (

    select * from {{ source('outreach_', 'account') }}

),

renamed as (

    select

        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('outreach_', 'account')),
                staging_columns = get_staging_outreach_account_columns()
            )
        }}

    from source

)

select
    *
from renamed
