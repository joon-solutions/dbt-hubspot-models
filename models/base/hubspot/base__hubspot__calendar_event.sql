with source as (

    select * from {{ source('hubspot', 'calendar_event') }}

),

renamed as (

    select
        id,
        event_type,
        event_date,
        category,
        category_id,
        content_id,
        state,
        campaign_guid,
        portal_id,
        name,
        description,
        url,
        owner_id,
        created_by,
        create_content,
        preview_key,
        template_path,
        social_username,
        social_display_name,
        avatar_url,
        is_recurring,
        content_group_id,
        group_id,
        group_order,
        user_id,
        _fivetran_synced

    from source

)

select * from renamed

