with source as (

    select * from {{ source('hubspot', 'email_event_deferred') }}

),

renamed as (

    select
        id as email_event_id,
        response,
        attempt,
        _fivetran_synced

    from source

)

select * from renamed

