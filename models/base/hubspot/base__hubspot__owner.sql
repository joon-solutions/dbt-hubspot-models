with source as (

    select * from {{ source('hubspot', 'owner') }}

),

renamed as (

    select
        owner_id,
        portal_id,
        type,
        first_name,
        last_name,
        email,
        created_at,
        updated_at,
        is_active,
        active_user_id,
        user_id_including_inactive,
        _fivetran_synced

    from source

)

select * from renamed