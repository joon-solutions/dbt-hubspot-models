--where each account is in a sequence
with seq_base as ( --PK: account_id| sequence_id
    select * 
    from {{ ref('int__outreach_sf_sequence') }}
),

---
opportunity_base as (
    select  *
    from {{ ref('int__outreach_sf_opportunity') }}
    where outreach_opportunity_id is null
),

account as (
    select * 
    from {{ ref('int__outreach_sf_account') }}
),

seq as (
    select  account.account_id, 
            seq_base.*
    from seq_base
    left join account on seq_base.outreach_account_id = account.outreach_account_id
),

opportunity as (
    select  account.account_id, 
            opportunity_base.*
    from opportunity_base
    left join account on opportunity_base.sf_account_id = account.sf_account_id
),

----a deal will be assigned to a sequence that has the last activity time closet to the time when the deal was opened
joins as ( --PK: account_id| sequence_id| opportunity_id
    select  seq.*,
            opportunity.opportunity_id,
            row_number() over (partition by opportunity.opportunity_id order by opportunity.open_at - seq.updated_at asc) as rnk
    from seq
    left join opportunity on seq.account_id = opportunity.account_id
    qualify rnk=1
),

final as (
    select 
        account_id
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
        count(case when status = 'open' then opportunity_id else null end) as total_open_deals,
        count(case when status = 'won' then opportunity_id else null end) as total_won_deals,
        count(case when status = 'won' then opportunity_id else null end) as total_lost_deals
    from joins
)

select * from joins






