with ticket_comment as (

    select *
    from {{ ref('int__zendesk__field_history_comments_unioned') }}
    where field_name = 'comment'

),

comment_role as (
    select
        *,
        case when user_role = 'end-user' then 'external_comment'
            when user_role in ('agent', 'admin') then 'internal_comment'
            else 'unknown' end as commenter_role
    from ticket_comment
),

add_previous_commenter_role as (
    /*
    In int_zendesk__ticket_reply_times we will only be focusing on reply times between public tickets.
    The below union explicitly identifies the previous commentor roles of public and not public comments.
    */
    select
        *,
        lag(commenter_role, 1, 'first_comment') over (partition by ticket_id order by valid_starting_at) as previous_commenter_role,
        lag(valid_starting_at) over (partition by ticket_id order by valid_starting_at) as previous_comment_at
    from comment_role
    where is_public

    union all

    select
        *,
        'non_public_comment' as previous_commenter_role,
        null as previous_comment_at
    from comment_role
    where not is_public
),

reply_timestamps as (
    select
        *,
        case when is_public = true and commenter_role = 'internal_comment' and previous_commenter_role in ('external_comment', 'first_comment')
                then ({{ dbt_utils.datediff(
                            'previous_comment_at',
                            'valid_starting_at',
                            'second') }} / 60)
        end as reply_time_calendar_minutes
    from add_previous_commenter_role
),
--avg snowflake returns the average of non-NULL records, need double check if using different database

aggregates as (
    select
        ticket_id,
        avg(reply_time_calendar_minutes) as avg_reply_time_calendar_minutes,
        sum(case when commenter_role = 'internal_comment' and is_public = true
            then 1
            else 0
            end) as count_public_agent_comments,
        sum(case when commenter_role = 'internal_comment'
            then 1
            else 0
            end) as count_agent_comments,
        sum(case when commenter_role = 'external_comment'
            then 1
            else 0
            end) as count_end_user_comments,
        sum(case when is_public = true
            then 1
            else 0
            end) as count_public_comments,
        sum(case when is_public = false
            then 1
            else 0
            end) as count_internal_comments,
        count(distinct case when commenter_role = 'internal_comment'
            then user_id
            end ) as count_ticket_handoffs,
        count(*) as total_comments
    from reply_timestamps
    group by 1

),

final as (
    select
        *,
        count_public_agent_comments = 1 as is_one_touch_resolution,
        count_public_agent_comments = 2 as is_two_touch_resolution
    from aggregates
)

select * from final
