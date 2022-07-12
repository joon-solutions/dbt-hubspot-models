with source as (

    select * from {{ source('hubspot', 'calendar_user') }}

),

renamed as (

    select
        calendar_event_id,
        user_id,
        _fivetran_synced

    from source

)

select * from renamed