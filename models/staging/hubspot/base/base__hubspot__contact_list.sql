{{ config(enabled = var('contact_list_enabled') ) }}

with source as (

    select * from {{ source('hubspot', 'contact_list') }}

),

renamed as (

    select
        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('hubspot', 'contact_list')),
                staging_columns = get_hubspot_contact_list_columns()
            )
        }}
    from source

)

select * from renamed
