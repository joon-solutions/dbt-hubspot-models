with source as (

    select * from {{ source('hubspot', 'contact_property_history') }}

),

renamed as (

    select
        contact_id,
        name,
        timestamp,
        value,
        source_id,
        source,
        _fivetran_synced,
        _fivetran_start,
        _fivetran_end,
        _fivetran_active

    from source

)

select * from renamed