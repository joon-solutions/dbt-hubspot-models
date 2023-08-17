{{ config(enabled = var('contact_enabled', False) ) }}

with source as (

    select * from {{ source(var('hubspot_schema', 'hubspot'), 'contact') }}

),

renamed as (

    select
        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source(var('hubspot_schema', 'hubspot'), 'contact')),
                staging_columns=get_hubspot_contact_columns()
            )
        }}

    from source

)

select * from renamed
