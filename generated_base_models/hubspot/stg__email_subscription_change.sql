with source as (

    select * from {{ source('hubspot', 'email_subscription_change') }}

),

renamed as (

    select
        recipient,
        timestamp,
        change,
        change_type,
        portal_id,
        source,
        caused_by_event_id,
        email_subscription_id,
        _fivetran_id,
        _fivetran_synced

    from source

)

select * from renamed