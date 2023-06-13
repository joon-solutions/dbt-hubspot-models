{{ config(enabled=var('zendesk_enabled', False)) }}

with base as (

    select *
    from {{ source('zendesk', 'ticket_field_history') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('zendesk', 'ticket_field_history')),
                staging_columns=get_zendesk_ticket_field_history_columns()
            )
        }}

    from base
),

final as (

    select
        ticket_id,
        field_name,
        valid_starting_at,
        lead(valid_starting_at) over (partition by ticket_id, field_name order by valid_starting_at) as valid_ending_at,
        value,
        user_id

    from fields
)

select
    *,
    {{ dbt_utils.surrogate_key(['field_name','ticket_id','valid_starting_at']) }} as ticket_field_id
from final
