{{ config(enabled = var('email_subscription_change_enabled') ) }}

with source as (

    select * from {{ source('hubspot', 'email_subscription_change') }}

),
---caused_by_event_id:recipient - n:1

renamed as (

    select
        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('hubspot', 'email_subscription_change')),
                staging_columns = get_hubspot_email_subscription_change_columns()
            )
        }}

    from source

)

select * from renamed
