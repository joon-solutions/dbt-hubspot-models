{{ config(enabled = var('contact_list_member_enabled', False) ) }}

with source as (

    select * from {{ source('hubspot', 'contact_list_member') }}

),

renamed as (

    select

        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('hubspot', 'contact_list_member')),
                staging_columns = get_hubspot_contact_list_member_columns()
            )
        }}

    from source

)

select
    *,
    {{ dbt_utils.surrogate_key(['contact_id','contact_list_id']) }} as id

from renamed
