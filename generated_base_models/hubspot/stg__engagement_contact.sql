with source as (

    select * from {{ source('hubspot', 'engagement_contact') }}

),

renamed as (

    select
        engagement_id,
        contact_id,
        _fivetran_synced

    from source

)

select * from renamed