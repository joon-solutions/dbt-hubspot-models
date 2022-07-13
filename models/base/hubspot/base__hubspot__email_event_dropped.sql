with source as (

    select * from {{ source('hubspot', 'email_event_dropped') }}

),

renamed as (

    select
        id as email_event_id,
        subject
        from,
        reply_to,
        cc,
        bcc,
        drop_reason,
        drop_message,
        _fivetran_synced

    from source

)

select * from renamed

