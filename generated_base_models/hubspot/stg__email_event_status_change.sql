with source as (

    select * from {{ source('hubspot', 'email_event_status_change') }}

),

renamed as (

    select
        id,
        source,
        requested_by,
        portal_subscription_status,
        subscriptions,
        bounced,
        _fivetran_synced

    from source

)

select * from renamed