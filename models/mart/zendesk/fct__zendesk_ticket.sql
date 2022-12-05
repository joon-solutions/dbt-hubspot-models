with ticket as (

    select *
    from {{ ref('int__zendesk__ticket_aggregates') }}

),



users as (

    select *
    from {{ ref('int__zendesk__user_aggregates') }}

),

organization as (

    select *
    from {{ ref('int__zendesk__organization_aggregates') }}
),

ticket_comments as (

    select *
    from {{ ref('int_zendesk__ticket_comments') }}
),

{% if var('zendesk__ticket_field_history', True) %}

latest_satisfaction_ratings as (

    select *
    from {{ ref('int__zendesk__ticket_historical_satisfaction') }}

),

ticket_resolution_times as (

    select *
    from {{ ref('int__zendesk__ticket_resolution_times') }}
),

ticket_work_times as (

  select *
  from {{ ref('int__zendesk__ticket_work_times') }}
),

{% endif %}

ticket_enriched_1 as (
    select
        ticket.*,
        ---ticket comments
        ticket_comments.avg_reply_time_calendar_minutes,
        ticket_comments.count_public_agent_comments,
        ticket_comments.count_agent_comments,
        ticket_comments.count_end_user_comments,
        ticket_comments.count_public_comments,
        ticket_comments.count_internal_comments,
        ticket_comments.count_ticket_handoffs,
        ticket_comments.total_comments,
        ticket_comments.is_one_touch_resolution,
        ticket_comments.is_two_touch_resolution,
        --If you use zendesk__domain_names tags this will be included, if not it will be ignored.
        {% if var('zendesk__domain_names', True) %}
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
        {% if var('zendesk__organization_tag', True) %}
        requester_org.organization_tags as requester_organization_tags,
        {% endif %}

        --- Requester Users
        requester.external_id as requester_external_id,
        requester.created_at as requester_created_at,
        requester.updated_at as requester_updated_at,
        requester.user_role as requester_role,
        requester.user_email as requester_email,
        requester.user_name as requester_name,
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
        submitter.user_role as submitter_role,
        submitter.user_role in ('agent', 'admin') as is_agent_submitted,
        submitter.user_email as submitter_email,
        submitter.user_name as submitter_name,
        submitter.is_active as is_submitter_active,
        submitter.locale as submitter_locale,
        submitter.time_zone as submitter_time_zone,
        --- Assignee Users
        assignee.external_id as assignee_external_id,
        assignee.user_role as assignee_role,
        assignee.user_email as assignee_email,
        assignee.user_name as assignee_name,
        assignee.is_active as is_assignee_active,
        assignee.locale as assignee_locale,
        assignee.time_zone as assignee_time_zone,
        assignee.last_login_at as assignee_last_login_at,
        ---Organization
        organization.organization_name

    from ticket
    left join ticket_comments on ticket.ticket_id = ticket_comments.ticket_id --one-to-one
    left join organization on ticket.organization_id = organization.organization_id --many-to-one relationship
    --Requester
    left join users as requester on ticket.requester_id = requester.user_id --many-to-one relationship
    left join organization as requester_org on requester.organization_id = requester_org.organization_id --many-to-one relationship
    --Submitter
    left join users as submitter on ticket.submitter_id = submitter.user_id --many-to-one relationship
    --Assignee Joins
    left join users as assignee on ticket.assignee_id = assignee.user_id --many-to-one relationship

),

{% if var('zendesk__ticket_field_history', True) %}

ticket_enriched_2 as (
    
    select
        ticket_enriched_1.*,
        ---resolution metrics
        ticket_resolution_times.first_assignee_id, ---add assignee_name?
        ticket_resolution_times.first_assignment_to_resolution_calendar_minutes,
        ticket_resolution_times.last_assignee_id, ---add assigsnee_name?
        ticket_resolution_times.last_assignment_to_resolution_calendar_minutes,
        ticket_resolution_times.first_resolution_calendar_minutes,
        ticket_resolution_times.final_resolution_calendar_minutes,
        --- satisfaction_ratings
        latest_satisfaction_ratings.count_satisfaction_scores,
        latest_satisfaction_ratings.first_satisfaction_score,
        latest_satisfaction_ratings.latest_satisfaction_score,
        latest_satisfaction_ratings.first_numerical_satisfaction_score,
        latest_satisfaction_ratings.latest_numerical_satisfaction_score,
        latest_satisfaction_ratings.latest_satisfaction_comment,
        latest_satisfaction_ratings.latest_satisfaction_reason,
        latest_satisfaction_ratings.is_good_to_bad_satisfaction_score,
        latest_satisfaction_ratings.is_bad_to_good_satisfaction_score,
        ---ticket_work_times
        ticket_work_times.agent_wait_time_in_minutes,
        ticket_work_times.requester_wait_time_in_minutes,
        ticket_work_times.agent_work_time_in_minutes,
        ticket_work_times.on_hold_time_in_minutes,
        ticket_work_times.new_status_duration_minutes,
        ticket_work_times.open_status_duration_minutes
        
    from ticket_enriched_1
    left join latest_satisfaction_ratings on ticket_enriched_1.ticket_id = latest_satisfaction_ratings.ticket_id --one-to-one relationship
    left join ticket_resolution_times on ticket_enriched_1.ticket_id = ticket_resolution_times.ticket_id --one-to-one
    
    left join ticket_work_times on ticket_enriched_1.ticket_id = ticket_work_times.ticket_id --one-to-one

)

select * from ticket_enriched_2

{% else %}

select * from ticket_enriched_1

{% endif %}
