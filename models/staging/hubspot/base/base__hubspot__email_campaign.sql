{{ config(enabled = var('email_campaign_enabled') ) }}

with source as (

    select * from {{ source('hubspot', 'email_campaign') }}

),

renamed as (

    select
        id as email_campaign_id,
        app_id,
        app_name,
        content_id,
        name as email_campaign_name,
        num_included,
        num_queued,
        sub_type,
        subject,
        type as email_campaign_type,
        _fivetran_synced

    from source

)

select * from renamed
