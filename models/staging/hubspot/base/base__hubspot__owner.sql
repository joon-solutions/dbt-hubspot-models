{{ config(enabled = var('hubspot__owner', False) ) }}

with source as (

    select * from {{ source(var('hubspot_schema', 'hubspot'), 'owner') }}

),

renamed as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source(var('hubspot_schema', 'hubspot'), 'owner')),
                staging_columns=get_hubspot_owner_columns()
            )
        }}
    from source

)

select
    *,
    trim( {{ dbt_utils.concat(['first_name', "' '", 'last_name']) }} ) as full_name
from renamed
