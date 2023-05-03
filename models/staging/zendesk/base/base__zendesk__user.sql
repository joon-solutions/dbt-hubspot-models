{{ config(enabled=var('zendesk_enabled')) }}

with base as (

    select *
    from {{ source('zendesk', 'user') }}

),

fields as (

    select

        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('zendesk', 'user')),
                staging_columns=get_zendesk_user_columns()
            )
        }}

    from base
),

final as (

    select
        user_id,
        external_id,
        _fivetran_synced,
        last_login_at,
        created_at,
        updated_at,
        user_email,
        user_name,
        organization_id,
        user_role,
        ticket_restriction,
        time_zone,
        locale,
        is_active,
        is_suspended
    from fields
)

select *
from final
