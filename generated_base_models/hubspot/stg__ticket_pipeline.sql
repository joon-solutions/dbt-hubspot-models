with source as (

    select * from {{ source('hubspot', 'ticket_pipeline') }}

),

renamed as (

    select
        pipeline_id,
        label,
        active,
        display_order,
        object_type_id,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed