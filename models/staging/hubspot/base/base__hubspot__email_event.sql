{{ config(enabled = var('email_event_enabled') ) }}

with source as (

    select * from {{ source('hubspot', 'email_event') }}

),

renamed as (

    select
        id as email_event_id,
        created,
        type as event_type,
        recipient,
        portal_id,
        app_id,
        filtered_event,
        email_campaign_id,
        sent_by_id as email_send_id,
        sent_by_created as email_send_at,
        caused_by_id,
        caused_by_created,
        obsoleted_by_id,
        obsoleted_by_created,
        _fivetran_synced

    from source

)

select * from renamed

