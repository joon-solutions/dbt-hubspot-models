with tickets as (
    select *
    from {{ ref('base__zendesk__ticket') }}

),

ticket_tags as (

    select *
    from {{ ref('base__zendesk__ticket_tag') }}

),

brands as (

    select *
    from {{ ref('base__zendesk__brand') }}

),

ticket_group as (

    select *
    from {{ ref('base__zendesk__group') }}

),

ticket_tag_aggregate as (
    select
        ticket_id,
        {{ fivetran_utils.string_agg( 'tags', "', '" ) }} as ticket_tags
    from ticket_tags
    group by 1

),

--If you use using_ticket_form_history this will be included, if not it will be ignored.
{% if var('using_ticket_form_history', True) %}
latest_ticket_form as (

    select *
    from {{ ref('stg__zendesk__latest_ticket_form') }}

),
{% endif %}

final as (
    select
        tickets.*,
        tickets.ticket_type = 'incident' as is_incident,
        brands.brand_name,
        ticket_tag_aggregate.ticket_tags,
        --If you use using_ticket_form_history this will be included, if not it will be ignored.
        {% if var('using_ticket_form_history', True) %}
            latest_ticket_form.ticket_form_name,
        {% endif %}
        ticket_group.group_name
    from tickets
    left join ticket_tag_aggregate on tickets.ticket_id = ticket_tag_aggregate.ticket_id --one-to-one
    left join brands on tickets.brand_id = brands.brand_id --many-to-one
    left join ticket_group on tickets.group_id = ticket_group.group_id --many-to-one
    --If you use using_ticket_form_history this will be included, if not it will be ignored.
    {% if var('using_ticket_form_history', True) %}
        left join latest_ticket_form on tickets.ticket_form_id = latest_ticket_form.ticket_form_id --many-to-one
    {% endif %}
)

select *
from final
