with source as (

    select * from {{ source('hubspot', 'ticket_contact') }}

),

renamed as (

    select
        ticket_id,
        contact_id,
        _fivetran_synced

    from source

)

select * from renamed