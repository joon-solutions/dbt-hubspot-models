with source as (

    select * from {{ source('hubspot', 'email_event_click') }}

),

renamed as (

    select
        id as email_event_id,
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

