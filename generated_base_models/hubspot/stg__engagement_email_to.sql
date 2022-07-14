with source as (

    select * from {{ source('hubspot', 'engagement_email_to') }}

),

renamed as (

    select
        engagement_id,
        email,
        first_name,
        last_name,
        _fivetran_synced

    from source

)

select * from renamed