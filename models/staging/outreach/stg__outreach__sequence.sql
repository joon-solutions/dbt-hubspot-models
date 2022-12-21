with seq as (
    select *
    from {{ ref('base__outreach__sequence') }}
),

seq_state as (
    select *
    from {{ ref('base__outreach__sequence_state') }}
),

seqstate_agg as (
    select
        sequence_id,
        account_id,
        sum(bounce_count) as bounce_count,
        sum(click_count) as click_count,
        sum(deliver_count) as deliver_count,
        sum(failure_count) as failure_count,
        sum(negative_reply_count) as negative_reply_count,
        sum(neutral_reply_count) as neutral_reply_count,
        sum(open_count) as open_count,
        sum(opt_out_count) as opt_out_count,
        sum(positive_reply_count) as positive_reply_count,
        sum(reply_count) as reply_count,
        sum(schedule_count) as schedule_count
    from seq_state
    group by 1, 2
),

final as (
    select
        seqstate_agg.*,
        seq.sequence_name,
        seq.sequence_type,
        seq.schedule_interval_type
    from seqstate_agg
    left join seq on seqstate_agg.sequence_id = seq.sequence_id --many-to-one
)

select
    *,
    {{ dbt_utils.surrogate_key(['sequence_id','account_id']) }} as id
from final
