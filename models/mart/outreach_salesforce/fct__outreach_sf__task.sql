{{ config(enabled=var('salesforce__task_enabled', True)) }}

with task_base as (
    select *
    from {{ ref('int__outreach_sf__task') }}
    where is_completed = true
),

opportunity_base as (
    select
        outreach_account_id,
        sf_account_id,
        amount,
        created_at,
        close_date,
        opportunity_status
    from {{ ref('int__outreach_sf__opportunity') }}
),

account as (
    select *
    from {{ ref('int__outreach_sf__account') }}
),

task as (
    select
        account.account_id,
        task_base.*,
        lead(task_base.completed_at) over (partition by account.account_id order by task_base.completed_at asc) as next_task_completed_at,
        datediff(day, task_base.completed_at, next_task_completed_at) as task_day_intervals
    from task_base
    left join account on task_base.outreach_account_id = account.outreach_account_id or task_base.sf_account_id = account.sf_account_id
),

opportunity as (
    select
        account.account_id,
        opportunity_base.amount,
        opportunity_base.created_at as first_opportunity_open_at,
        case when opportunity_base.opportunity_status = 'Won' then opportunity_base.close_date end as first_opportunity_closed_at,
        row_number() over (partition by account.account_id order by opportunity_base.created_at asc) as rnk
    from opportunity_base
    left join account on opportunity_base.outreach_account_id = account.outreach_account_id or opportunity_base.sf_account_id = account.sf_account_id
    qualify rnk = 1
),

touches_til_open_deal as (
    select
        task.account_id,
        task.task_id,
        task.completed_at,
        task.task_action_type,
        task.task_day_intervals,
        opportunity.first_opportunity_open_at,
        opportunity.first_opportunity_closed_at,
        opportunity.amount,
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
        ---- point
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
        1.0 / total_touches as linear_points,
        ---- deal amount
        case
            when total_touches = 1 then amount
            when total_touches = 2 then amount / 2
            when touch_number = 1 then amount * 0.4
            when touch_number = total_touches then amount * 0.4
            else amount * 0.2 / (total_touches - 2)
        end as forty_twenty_forty_amounts,
        case
            when touch_number = 1 then amount
            else 0.0
        end as first_touch_amounts,
        case
            when touch_number = total_touches then amount
            else 0.0
        end as last_touch_amounts,
        amount / total_touches as linear_amounts

    from touches_til_open_deal
),

touches_til_close_deal as (
    select
        task.account_id,
        task.task_id,
        task.completed_at,
        task.task_action_type,
        task.task_day_intervals,
        opportunity.first_opportunity_open_at,
        opportunity.first_opportunity_closed_at,
        opportunity.amount,
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
        ---- total point of each conversion = 1.0
        case
            when total_touches = 1 then 1.0 -- if theres only 1 touch, allocate all points to it
            when total_touches = 2 then 0.5 -- if therere 2 touches, divide equally
            when touch_number = 1 then 0.4
            when touch_number = total_touches then 0.4
            else 0.2 / (total_touches - 2) -- if > 2 touches, 40% to the first, 40$ to the second, 20% left allocated equally to touches in between
        end as forty_twenty_forty_points,
        --- allocate all points to first touch
        case
            when touch_number = 1 then 1.0
            else 0.0
        end as first_touch_points,
        --- allocate all points to last touch
        case
            when touch_number = total_touches then 1.0
            else 0.0
        end as last_touch_points,
        --- allocate all points to every touch equally
        1.0 / total_touches as linear_points,

        ---- total point of each conversion = deal amount
        case
            when total_touches = 1 then amount
            when total_touches = 2 then amount / 2
            when touch_number = 1 then amount * 0.4
            when touch_number = total_touches then amount * 0.4
            else amount * 0.2 / (total_touches - 2)
        end as forty_twenty_forty_amounts,
        case
            when touch_number = 1 then amount
            else 0.0
        end as first_touch_amounts,
        case
            when touch_number = total_touches then amount
            else 0.0
        end as last_touch_amounts,
        amount / total_touches as linear_amounts
    from touches_til_close_deal
),

final as (
    select * from allocation_til_open_deal
    union all
    select * from allocation_til_close_deal
)

select * from final
