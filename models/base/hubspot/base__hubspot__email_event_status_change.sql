with source as (

    select * from {{ source('hubspot', 'email_event_status_change') }}

),

renamed as (

    select
        id as email_event_id,
        source,
        requested_by,
        portal_subscription_status as subscription_status,
        subscriptions,
        bounced,
        _fivetran_synced

    from source

)

select * from renamed

