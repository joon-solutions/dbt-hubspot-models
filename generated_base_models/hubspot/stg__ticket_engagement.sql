with source as (

    select * from {{ source('hubspot', 'ticket_engagement') }}

),

renamed as (

    select
        ticket_id,
        engagement_id,
        _fivetran_synced

    from source

)

select * from renamed