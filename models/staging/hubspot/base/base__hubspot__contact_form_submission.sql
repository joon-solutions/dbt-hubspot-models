{{ config(enabled = var('contact_form_submission_enabled', False) ) }}

with source as (

    select * from {{ source(var('hubspot_schema', 'hubspot'), 'contact_form_submission') }}

),

renamed as (

    select

        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source(var('hubspot_schema', 'hubspot'), 'contact_form_submission')),
                staging_columns = get_hubspot_contact_form_submission_columns()
            )
        }}

    from source

)

select
    *,
    {{ dbt_utils.surrogate_key(['contact_id','conversion_id']) }} as id

from renamed
