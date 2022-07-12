with source as (

    select * from {{ source('hubspot', 'email_subscription') }}

),

renamed as (

    select
        id,
        portal_id,
        name,
        description,
        active,
        _fivetran_synced

    from source

)

select * from renamed