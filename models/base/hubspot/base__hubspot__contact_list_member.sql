with source as (

    select * from {{ source('hubspot', 'contact_list_member') }}

),

renamed as (

    select
        contact_id,
        contact_list_id,
        added_at,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed

