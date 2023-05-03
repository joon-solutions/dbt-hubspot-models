{{ config(enabled=var('zendesk_enabled')) }}

with base as (

    select *
    from {{ source('zendesk', 'ticket_tag') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('zendesk', 'ticket_tag')),
                staging_columns=get_zendesk_ticket_tag_columns()
            )
        }}

    from base
),

final as (

    select
        ticket_id,
        tags, --need to recheck
        {{ dbt_utils.surrogate_key(['ticket_id','tags']) }} as unique_id
    from fields
)

select *
from final
