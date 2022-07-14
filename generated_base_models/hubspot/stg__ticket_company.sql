with source as (

    select * from {{ source('hubspot', 'ticket_company') }}

),

renamed as (

    select
        ticket_id,
        company_id,
        _fivetran_synced

    from source

)

select * from renamed