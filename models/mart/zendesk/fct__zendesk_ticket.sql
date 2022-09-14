with ticket as (

    select *
    from {{ ref('int__zendesk__ticket_aggregates') }}

),

latest_satisfaction_ratings as (

    select *
    from {{ ref('int__zendesk__ticket_historical_satisfaction') }}

),

users as (

    select *
    from {{ ref('int__zendesk__user_aggregates') }}

),

organization as (

    select *
    from {{ ref('int__zendesk__organization_aggregates') }}
),

final as (
    select
        ticket.*,
        --- satisfaction_ratings
        latest_satisfaction_ratings.count_satisfaction_scores,
        latest_satisfaction_ratings.first_satisfaction_score,
        latest_satisfaction_ratings.latest_satisfaction_score,
        latest_satisfaction_ratings.latest_satisfaction_comment,
        latest_satisfaction_ratings.latest_satisfaction_reason,
        latest_satisfaction_ratings.is_good_to_bad_satisfaction_score,
        latest_satisfaction_ratings.is_bad_to_good_satisfaction_score,

        --If you use using_domain_names tags this will be included, if not it will be ignored.
        {% if var('using_domain_names', True) %}
        organization.domain_names as ticket_organization_domain_names,
        requester_org.domain_names as requester_organization_domain_names,
        {% endif %}

        --If you use using_user_tags this will be included, if not it will be ignored.
        {% if var('using_user_tags', True) %}
            requester.user_tags as requester_tag,
            submitter.user_tags as submitter_tag,
            assignee.user_tags as assignee_tag,
        {% endif %}

        --If you use organization tags this will be included, if not it will be ignored.
        {% if var('using_organization_tags', True) %}
        requester_org.organization_tags as requester_organization_tags,
        {% endif %}

        --- Requester Users
        requester.external_id as requester_external_id,
        requester.created_at as requester_created_at,
        requester.updated_at as requester_updated_at,
        requester.role as requester_role,
        requester.email as requester_email,
        requester.name as requester_name,
        requester.is_active as is_requester_active,
        requester.locale as requester_locale,
        requester.time_zone as requester_time_zone,
        requester.last_login_at as requester_last_login_at,
        requester.organization_id as requester_organization_id,
        requester_org.organization_name as requester_organization_name,
        requester_org.external_id as requester_organization_external_id,
        requester_org.created_at as requester_organization_created_at,
        requester_org.updated_at as requester_organization_updated_at,
        --- Submitter Users
        submitter.external_id as submitter_external_id,
        submitter.role as submitter_role,
        submitter.role in ('agent', 'admin') as is_agent_submitted,
        submitter.email as submitter_email,
        submitter.name as submitter_name,
        submitter.is_active as is_submitter_active,
        submitter.locale as submitter_locale,
        submitter.time_zone as submitter_time_zone,
        --- Assignee Users
        assignee.external_id as assignee_external_id,
        assignee.role as assignee_role,
        assignee.email as assignee_email,
        assignee.name as assignee_name,
        assignee.is_active as is_assignee_active,
        assignee.locale as assignee_locale,
        assignee.time_zone as assignee_time_zone,
        assignee.last_login_at as assignee_last_login_at,
        ---Organization
        organization.organization_name

    from ticket
    left join latest_satisfaction_ratings on ticket.ticket_id = latest_satisfaction_ratings.ticket_id --one-to-one relationship
    left join organization on ticket.organization_id = organization.organization_id --many-to-one relationship
    --Requester
    left join users as requester on ticket.requester_id = requester.user_id --many-to-one relationship
    left join organization as requester_org on requester.organization_id = requester_org.organization_id --many-to-one relationship
    --Submitter
    inner join users as submitter on ticket.submitter_id = submitter.user_id --many-to-one relationship
    --Assignee Joins
    left join users as assignee on ticket.assignee_id = assignee.user_id --many-to-one relationship

)

select * from final
