with source as (

    select * from {{ source('hubspot', 'email_event_sent') }}

),

renamed as (

    select
        id,
        subject,
        from,
        reply_to,
        cc,
        bcc,
        _fivetran_synced

    from source

)

select * from renamed