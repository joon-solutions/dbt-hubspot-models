{{ config(enabled=var('zendesk_enabled', False)) }}

with organizations as (

    select *
    from {{ ref('base__zendesk__organization') }}

),

--If you use organization tags this will be included, if not it will be ignored.
{% if var('zendesk__organization_tag', True) %}
organization_tags as (

    select * 
    from {{ ref('base__zendesk__organization_tag') }}

),

tag_aggregates as (
    select
        organization_id,
        {{ fivetran_utils.string_agg('tags', "', '" ) }} as organization_tags
    from organization_tags
    group by 1

),

{% endif %}

--If you use zendesk__domain_names tags this will be included, if not it will be ignored.
{% if var('zendesk__domain_names', True) %}

domain_names as (

    select *
    from {{ ref('base__zendesk__domain_name') }}

),

domain_aggregates as (
    select
        organization_id,
        {{ fivetran_utils.string_agg('domain_name', "', '" ) }} as domain_names
    from domain_names
    group by 1

),
{% endif %}

final as (
    select
        organizations.*

        --If you use organization tags this will be included, if not it will be ignored.
        {% if var('zendesk__organization_tag', True) %}
        , tag_aggregates.organization_tags
        {% endif %}

        --If you use zendesk__domain_names tags this will be included, if not it will be ignored.
        {% if var('zendesk__domain_names', True) %}
        , domain_aggregates.domain_names
        {% endif %}

    from organizations

    --If you use zendesk__domain_names tags this will be included, if not it will be ignored.
    {% if var('zendesk__domain_names', True) %}
    left join domain_aggregates on organizations.organization_id = domain_aggregates.organization_id --one-to-one
    {% endif %}

    --If you use organization tags this will be included, if not it will be ignored.
    {% if var('zendesk__organization_tag', True) %}
    left join tag_aggregates on organizations.organization_id = tag_aggregates.organization_id --one-to-one
    {% endif %}
)

select *
from final
