with source as (

    select * from {{ source('hubspot', 'property') }}

),

renamed as (

    select
        _fivetran_id,
        hubspot_object,
        name,
        label,
        description,
        group_name,
        type,
        field_type,
        calculated,
        hubspot_defined,
        _fivetran_synced

    from source

)

select * from renamed