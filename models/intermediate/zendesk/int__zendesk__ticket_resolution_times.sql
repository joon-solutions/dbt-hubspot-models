{{ config(enabled=var('zendesk_enabled', false) and var("using_user_tags", false)) }}

with ticket_history as (
    select *
    from {{ ref('int__zendesk__field_history_comments_unioned') }}
),

assignee_history as (

    select
        ticket_id,
        first_value(valid_starting_at) over (partition by ticket_id order by valid_starting_at) as first_agent_assignment_date,
        first_value(value) over (partition by ticket_id order by valid_starting_at) as first_assignee_id,
        first_value(valid_starting_at) over (partition by ticket_id order by valid_starting_at desc) as last_agent_assignment_date,
        first_value(value) over (partition by ticket_id order by valid_starting_at desc) as last_assignee_id,
        row_number() over (partition by ticket_id order by random()) as rnk
    from ticket_history
    where field_name = 'assignee_id'
    qualify rnk = 1

),

resolution_time as (

    select
        ticket_id,
        min(case when value = 'new' then valid_starting_at end) as created_at,
        min(case when value = 'solved' then valid_starting_at end) as first_solved_at,
        max(case when value = 'solved' then valid_starting_at end) as last_solved_at
    from ticket_history
    where field_name = 'status'
    group by 1

),

final as (
    select
        coalesce(assignee_history.ticket_id, resolution_time.ticket_id) as ticket_id,
        assignee_history.first_assignee_id,
        assignee_history.last_assignee_id,
        {{ dbt_utils.datediff(
            'assignee_history.first_agent_assignment_date', 
            'resolution_time.last_solved_at',
            'minute' ) }} as first_assignment_to_resolution_calendar_minutes,
        {{ dbt_utils.datediff(
            'assignee_history.last_agent_assignment_date', 
            'resolution_time.last_solved_at',
            'minute' ) }} as last_assignment_to_resolution_calendar_minutes,
        {{ dbt_utils.datediff(
            'resolution_time.created_at', 
            'resolution_time.first_solved_at',
            'minute' ) }} as first_resolution_calendar_minutes,
        {{ dbt_utils.datediff(
            'resolution_time.created_at', 
            'resolution_time.last_solved_at',
            'minute') }} as final_resolution_calendar_minutes
    from assignee_history
    full join resolution_time on assignee_history.ticket_id = resolution_time.ticket_id
)

select * from final
