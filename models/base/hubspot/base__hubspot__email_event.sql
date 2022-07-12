with source as (

    select * from {{ source('hubspot', 'email_event') }}

),

renamed as (

    select
        id,
        created,
        type,
        recipient,
        portal_id,
        app_id,
        filtered_event,
        email_campaign_id,
        sent_by_id,
        sent_by_created,
        caused_by_id,
        caused_by_created,
        obsoleted_by_id,
        obsoleted_by_created,
        _fivetran_synced

    from source

)

select * from renamed