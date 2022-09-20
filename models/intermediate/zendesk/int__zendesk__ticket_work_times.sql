--To disable this model, set the zendesk__domain_names variable within your dbt_project.yml file to False.
{{ config(enabled=var('zendesk__ticket_field_history', True)) }}

{% set status_dict = {
  "'pending'":"agent_wait_time_in_minutes", 
  "'new', 'open', 'hold'":"requester_wait_time_in_minutes",
  "'new', 'open'":"agent_work_time_in_minutes",
  "'hold'":"on_hold_time_in_minutes",
  "'new'":"new_status_duration_minutes",
  "'open'":"open_status_duration_minutes"
} %}

with ticket_historical_status as (

    select *
    from {{ ref('int__zendesk__field_history_comments_unioned') }}
    where field_name = 'status'

),

calendar_minutes as (

    select
        ticket_id,
        value as status,
        valid_starting_at,
        valid_ending_at,
        {{ dbt_utils.datediff(
        'valid_starting_at',
        "coalesce(valid_ending_at, " ~ dbt_utils.current_timestamp() ~ ")",
        'minute') }} as status_duration_calendar_minutes
    from ticket_historical_status

),

final as (

    select
        ticket_id,
        {% for status, metric_names in status_dict.items() %}
        sum(case when status in ({{ status }}) then status_duration_calendar_minutes else 0 end) as {{ metric_names }}{% if not loop.last %},{% endif %}
        {% endfor %}
    from calendar_minutes
    group by 1

)

select * from final
