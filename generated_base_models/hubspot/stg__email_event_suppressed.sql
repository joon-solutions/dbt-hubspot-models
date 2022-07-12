with source as (

    select * from {{ source('hubspot', 'email_event_suppressed') }}

),

renamed as (

    select
        id,
        from,
        subject,
        cc,
        bcc,
        reply_to,
        email_campaign_group_id,
        _fivetran_synced

    from source

)

select * from renamed