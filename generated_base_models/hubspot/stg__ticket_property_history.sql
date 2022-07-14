with source as (

    select * from {{ source('hubspot', 'ticket_property_history') }}

),

renamed as (

    select
        name,
        ticket_id,
        value,
        source_id,
        source,
        timestamp_instant,
        _fivetran_synced,
        _fivetran_start,
        _fivetran_end,
        _fivetran_active

    from source

)

select * from renamed