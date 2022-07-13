with source as (

    select * from {{ source('hubspot', 'email_event_spam_report') }}

),

renamed as (

    select
        id as email_event_id,
        user_agent,
        ip_address,
        _fivetran_synced

    from source

)

select * from renamed

