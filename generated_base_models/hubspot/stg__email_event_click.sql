with source as (

    select * from {{ source('hubspot', 'email_event_click') }}

),

renamed as (

    select
        id,
        ip_address,
        user_agent,
        browser,
        location,
        url,
        referer,
        _fivetran_synced

    from source

)

select * from renamed