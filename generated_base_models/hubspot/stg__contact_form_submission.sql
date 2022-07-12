with source as (

    select * from {{ source('hubspot', 'contact_form_submission') }}

),

renamed as (

    select
        contact_id,
        conversion_id,
        timestamp,
        title,
        form_id,
        portal_id,
        page_url,
        _fivetran_synced

    from source

)

select * from renamed