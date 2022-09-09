{{ config(enabled = var('email_event_enabled') ) }}

with source as (

    select * from {{ source('hubspot', 'email_event') }}

),

renamed as (

    select

        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('hubspot', 'email_event')),
                staging_columns = get_hubspot_email_event_columns()
            )
        }}

    from source

)

select * from renamed
