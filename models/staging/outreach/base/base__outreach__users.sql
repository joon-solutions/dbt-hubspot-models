{{ config(enabled = var('outreach_user', False) ) }}

with source as (

    select * from {{ source('outreach', 'users') }}

),

renamed as (

    select

        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('outreach', 'users')),
                staging_columns = get_staging_outreach_users_columns()
            )
        }}

    from source

)

select
    user_id,
    user_name,
    user_title,
    user_phone_number,
    trim(lower(user_email)) as user_email,
    updated_at,
    created_at
from renamed
