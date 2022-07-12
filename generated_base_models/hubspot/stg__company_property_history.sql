with source as (

    select * from {{ source('hubspot', 'company_property_history') }}

),

renamed as (

    select
        company_id,
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