with source as (

    select * from {{ source('hubspot', 'property_option') }}

),

renamed as (

    select
        label,
        property_id,
        value,
        display_order,
        double_data,
        hidden,
        read_only,
        _fivetran_synced

    from source

)

select * from renamed