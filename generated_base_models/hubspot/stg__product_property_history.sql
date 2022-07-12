with source as (

    select * from {{ source('hubspot', 'product_property_history') }}

),

renamed as (

    select
        name,
        product_id,
        timestamp,
        value,
        _fivetran_synced,
        _fivetran_start,
        _fivetran_end,
        _fivetran_active

    from source

)

select * from renamed