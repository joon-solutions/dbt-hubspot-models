with source as (

    select * from {{ source('hubspot', 'form') }}

),

renamed as (

    select
        guid,
        portal_id,
        name,
        action,
        method,
        css_class,
        redirect,
        submit_text,
        follow_up_id,
        notify_recipients,
        lead_nurturing_campaign_id,
        created_at,
        updated_at,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed

