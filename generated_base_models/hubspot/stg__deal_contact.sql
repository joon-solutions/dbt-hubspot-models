with source as (

    select * from {{ source('hubspot', 'deal_contact') }}

),

renamed as (

    select
        deal_id,
        contact_id,
        _fivetran_synced

    from source

)

select * from renamed