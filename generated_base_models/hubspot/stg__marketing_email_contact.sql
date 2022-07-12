with source as (

    select * from {{ source('hubspot', 'marketing_email_contact') }}

),

renamed as (

    select
        contact_id,
        marketing_email_id,
        is_contact_included,
        _fivetran_synced

    from source

)

select * from renamed