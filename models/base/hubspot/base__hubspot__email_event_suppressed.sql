with source as (

    select * from {{ source('hubspot', 'email_event_suppressed') }}

),

renamed as (

    select
        id as email_event_id,
        subject,
        cc,
        bcc,
        reply_to,
        email_campaign_group_id,
        _fivetran_synced

    from source

)

select * from renamed

