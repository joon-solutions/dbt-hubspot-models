with task_base as (
    select *
    from {{ ref('int__outreach_sf__task') }}
    where is_completed = true
),

opportunity_base as (
    select
        outreach_account_id,
        sf_account_id,
        min(created_at) as first_opportunity_open_at,
        min(case when opportunity_status = 'Won' then close_date end) as first_opportunity_closed_at
    from {{ ref('int__outreach_sf__opportunity') }}
    group by 1, 2
),

account as (
    select *
    from {{ ref('int__outreach_sf__account') }}
),

task as (
    select
        account.account_id,
        task_base.*
    from task_base
    left join account on task_base.outreach_account_id = account.outreach_account_id or task_base.sf_account_id = account.sf_account_id
),

opportunity as (
    select
        account.account_id,
        opportunity_base.*
    from opportunity_base
    left join account on opportunity_base.outreach_account_id = account.outreach_account_id or opportunity_base.sf_account_id = account.sf_account_id
),

touches_til_open_deal as (
    select
        task.account_id,
        task.task_id,
        task.completed_at,
        task.task_action_type,
        opportunity.first_opportunity_open_at,
        opportunity.first_opportunity_closed_at,
        count(*) over (partition by task.account_id) as total_touches,
        row_number() over (partition by task.account_id order by task.completed_at) as touch_number,
        'before open opportunity' as timeframe
    from task
    left join opportunity on task.account_id = opportunity.account_id -- many-to-one
    where task.completed_at <= opportunity.first_opportunity_open_at
-- and task.completed_at >= dateadd(days, -30, opportunity.first_opportunity_open_at) --limit tasks within "attribution window"
),

allocation_til_open_deal as (
    select
        *,
        case
            when total_touches = 1 then 1.0
            when total_touches = 2 then 0.5
            when touch_number = 1 then 0.4
            when touch_number = total_touches then 0.4
            else 0.2 / (total_touches - 2)
        end as forty_twenty_forty_points,
        case
            when touch_number = 1 then 1.0
            else 0.0
        end as first_touch_points,
        case
            when touch_number = total_touches then 1.0
            else 0.0
        end as last_touch_points,
        1.0 / total_touches as linear_points
    from touches_til_open_deal
),

touches_til_close_deal as (
    select
        task.account_id,
        task.task_id,
        task.completed_at,
        task.task_action_type,
        opportunity.first_opportunity_open_at,
        opportunity.first_opportunity_closed_at,
        count(*) over (partition by task.account_id) as total_touches,
        row_number() over (partition by task.account_id order by task.completed_at) as touch_number,
        'from open to close won opportunity' as timeframe
    from task
    left join opportunity on task.account_id = opportunity.account_id -- many-to-one
    where task.completed_at >= opportunity.first_opportunity_open_at
        and task.completed_at <= opportunity.first_opportunity_closed_at
),

allocation_til_close_deal as (
    select
        *,
        case
            when total_touches = 1 then 1.0
            when total_touches = 2 then 0.5
            when touch_number = 1 then 0.4
            when touch_number = total_touches then 0.4
            else 0.2 / (total_touches - 2)
        end as forty_twenty_forty_points,
        case
            when touch_number = 1 then 1.0
            else 0.0
        end as first_touch_points,
        case
            when touch_number = total_touches then 1.0
            else 0.0
        end as last_touch_points,
        1.0 / total_touches as linear_points
    from touches_til_close_deal
),

final as (
    select * from allocation_til_open_deal
    union all
    select * from allocation_til_close_deal
)

select * from final
