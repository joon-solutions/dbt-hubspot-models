with source as (

    select * from {{ source('hubspot', 'contact_list') }}

),

renamed as (

    select
        id as contact_list_id,
        name as contact_list_name,
        deleteable,
        dynamic,
        portal_id,
        updated_at,
        created_at,
        metadata_last_processing_state_change_at,
        metadata_processing,
        metadata_last_size_change_at,
        metadata_error,
        metadata_size,
        offset,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed

