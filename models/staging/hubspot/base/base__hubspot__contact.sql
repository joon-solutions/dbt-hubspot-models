{{ config(enabled = var('contact_enabled') ) }}

with source as (

    select * from {{ source('hubspot', 'contact') }}

),

renamed as (

    select
        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('hubspot', 'contact')),
                staging_columns=get_hubspot_contact_columns()
            )
        }}

    from source

)

select * from renamed
