--where each account is in a sequence
with seq_base as ( --PK: account_id| sequence_id
    select *
    from {{ ref('stg__outreach__sequence') }}
),

---
opportunity_base as (
    select *
    from {{ ref('int__outreach_sf__opportunity') }}
    where outreach_opportunity_id is null
),

account as (
    select *
    from {{ ref('int__outreach_sf__account') }}
),

seq as (
    select
        account.account_id,
        seq_base.sequence_id,
        seq_base.sequence_name,
        seq_base.created_at,
        seq_base.updated_at,
        seq_base.bounce_count,
        seq_base.click_count,
        seq_base.deliver_count,
        seq_base.failure_count,
        seq_base.negative_reply_count,
        seq_base.neutral_reply_count,
        seq_base.open_count,
        seq_base.opt_out_count,
        seq_base.positive_reply_count,
        seq_base.reply_count,
        seq_base.schedule_count
    from seq_base
    left join account on seq_base.account_id = account.outreach_account_id
),

opportunity as (
    select
        account.account_id,
        opportunity_base.*
    from opportunity_base
    left join account on opportunity_base.sf_account_id = account.sf_account_id
),

----a deal will be assigned to a sequence that has the last activity time closest to the time when the deal was opened
joins as ( --PK: account_id| sequence_id| opportunity_id
    select
        seq.*,
        abs(datediff(sec, seq.updated_at, opportunity.created_at)) as timediff,
        row_number() over (partition by opportunity.opportunity_id order by timediff asc) as rnk,
        case when rnk = 1 then opportunity.opportunity_id end as opportunity_id,
        case when rnk = 1 then opportunity.amount end as opportunity_amount,
        case when rnk = 1 then opportunity.count_won end as count_won,
        case when rnk = 1 then opportunity.count_lost end as count_lost,
        case when rnk = 1 then opportunity.amount_won end as amount_won,
        case when rnk = 1 then opportunity.amount_lost end as amount_lost
    from seq
    left join opportunity on seq.account_id = opportunity.account_id
),

agg as (
    select
        account_id,
        sequence_id,
        sequence_name,
        max(created_at) as created_at,
        max(updated_at) as updated_at,
        max(deliver_count) as total_deliver,
        max(failure_count) as total_failure,
        max(bounce_count) as total_bounce,
        max(click_count) as total_click,
        max(open_count) as total_open,
        max(negative_reply_count) as total_negative_reply,
        max(neutral_reply_count) as total_neutral_reply,
        max(opt_out_count) as total_opt_out,
        max(positive_reply_count) as total_positive_reply,
        max(reply_count) as total_reply,
        max(schedule_count) as total_schedule,
        ---opportunity
        coalesce(count(opportunity_id), 0) as total_deals,
        coalesce(sum(count_won), 0) as total_won_deals,
        coalesce(sum(count_lost), 0) as total_lost_deals,
        coalesce(sum(opportunity_amount), 0) as total_opportunity_amount,
        coalesce(sum(amount_won), 0) as total_won_deals_amount,
        coalesce(sum(amount_lost), 0) as total_lost_deals_amount
    from joins
    group by 1, 2, 3
),

final as (
    select
        *,
        total_deliver > 0 as has_delivered,
        total_open > 0 as has_opened,
        total_click > 0 as has_clicked,
        total_schedule > 0 as has_scheduled,
        total_deals > 0 as has_opened_deals,
        total_won_deals_amount > 0 as has_won_deals
    from agg
)

select
    *,
    {{ dbt_utils.surrogate_key(['sequence_id','account_id']) }} as id
from final
