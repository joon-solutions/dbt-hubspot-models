with source as (

    select * from {{ source('hubspot', 'email_event_bounce') }}

),

renamed as (

    select
        id,
        response,
        category,
        status,
        _fivetran_synced

    from source

)

select * from renamed