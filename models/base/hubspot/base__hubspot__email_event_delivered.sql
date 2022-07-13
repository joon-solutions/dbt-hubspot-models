with source as (

    select * from {{ source('hubspot', 'email_event_delivered') }}

),

renamed as (

    select
        id as email_event_id,
        response,
        smtp_id,
        _fivetran_synced

    from source

)

select * from renamed

