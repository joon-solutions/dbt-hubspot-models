{{ config(enabled=var('zendesk_enabled', False)) }}

with base as (

    select *
    from {{ source('zendesk', 'ticket') }}

),

fields as (

    select

        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('zendesk', 'ticket')),
                staging_columns=get_zendesk_ticket_columns()
            )
        }}

        --The below script allows for pass through columns.
        {% if var('zendesk__ticket_passthrough_columns',[]) != [] %}
        ,
        {{ var('zendesk__ticket_passthrough_columns') | join (", ") }}

        {% endif %}

    from base
),

final as (

    select
        ticket_id,
        _fivetran_synced,
        assignee_id,
        brand_id,
        created_at,
        updated_at,
        description,
        due_at,
        group_id,
        external_id,
        is_public,
        organization_id,
        priority,
        recipient,
        requester_id,
        status,
        subject,
        problem_id,
        submitter_id,
        ticket_form_id,
        lower(type) as ticket_type,
        url,
        created_channel,
        source_from_id,
        source_from_title,
        source_rel,
        source_to_address,
        source_to_name

        --The below script allows for pass through columns.
        {% if var('zendesk__ticket_passthrough_columns',[]) != [] %}
        ,
        {{ var('zendesk__ticket_passthrough_columns') | join (", ") }}

        {% endif %}

    from fields
)

select *
from final
