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
        opportunity.opportunity_id,
        opportunity.opportunity_status,
        abs(datediff(sec, seq.updated_at, opportunity.created_at)) as timediff,
        row_number() over (partition by opportunity.opportunity_id order by timediff asc) as rnk
    from seq
    left join opportunity on seq.account_id = opportunity.account_id
),

final as (
    select
        account_id,
        sequence_id,
        max(created_at) as created_at,
        max(updated_at) as updated_at,
        max(deliver_count) as deliver_count,
        max(failure_count) as failure_count,
        max(bounce_count) as bounce_count,
        max(click_count) as click_count,
        max(open_count) as open_count,
        max(negative_reply_count) as negative_reply_count,
        max(neutral_reply_count) as neutral_reply_count,
        max(opt_out_count) as opt_out_count,
        max(positive_reply_count) as positive_reply_count,
        max(reply_count) as reply_count,
        max(schedule_count) as schedule_count,
        coalesce(count(case when opportunity_status in ('Pipeline', 'Other') then opportunity_id end), 0) as total_open_deals,
        coalesce(count(case when opportunity_status = 'Won' then opportunity_id end), 0) as total_won_deals,
        coalesce(count(case when opportunity_status = 'Lost' then opportunity_id end), 0) as total_lost_deals
    from joins
    where rnk = 1 or opportunity_id is null
    group by 1, 2
)

select
    *,
    {{ dbt_utils.surrogate_key(['sequence_id','account_id']) }} as id
from final
