{{ config(enabled=var('zendesk_enabled')) }}

with base as (

    select *
    from {{ source('zendesk', 'organization') }}

),

fields as (

    select

        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('zendesk', 'organization')),
                staging_columns=get_zendesk_organization_columns()
            )
        }}

    from base
),

final as (

    select
        organization_id,
        created_at,
        updated_at,
        details,
        organization_name,
        external_id

    from fields
)

select *
from final
