with source as (

    select * from {{ source('hubspot', 'contact_identity_profile') }}

),

renamed as (

    select
        contact_id,
        vid,
        saved_at_timestamp,
        deleted_changed_timestamp,
        _fivetran_synced

    from source

)

select * from renamed