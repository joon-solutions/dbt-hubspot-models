with source as (

    select * from {{ source('hubspot', 'marketing_email_contact_list') }}

),

renamed as (

    select
        contact_list_id,
        marketing_email_id,
        is_mailing_list_included,
        _fivetran_synced

    from source

)

select * from renamed