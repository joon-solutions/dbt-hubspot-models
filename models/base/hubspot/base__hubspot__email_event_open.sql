with source as (

    select * from {{ source('hubspot', 'email_event_open') }}

),

renamed as (

    select
        id as email_event_id,
        ip_address,
        user_agent,
        browser,
        location,
        duration,
        _fivetran_synced

    from source

)

select * from renamed

