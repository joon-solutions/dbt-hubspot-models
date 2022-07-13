with source as (

    select * from {{ source('hubspot', 'email_event_sent') }}

),

renamed as (

    select
        id as email_send_id,
        subject,
        reply_to,
        cc,
        bcc,
        _fivetran_synced,
        identifier('from')

    from source

)

select * from renamed

