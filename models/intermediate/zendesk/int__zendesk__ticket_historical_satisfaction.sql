with satisfaction_updates as (

    select *
    from {{ ref('int__zendesk__field_history_comments_unioned') }}
    where field_name in ('satisfaction_score', 'satisfaction_comment', 'satisfaction_reason_code')

),

latest_reason as (
    select
        ticket_id,
        value as latest_satisfaction_reason,
        row_number() over (partition by ticket_id order by valid_starting_at desc) as rnk
    from satisfaction_updates
    where field_name = 'satisfaction_reason_code'
    qualify rnk = 1

),

latest_comment as (
    select
        ticket_id,
        value as latest_satisfaction_comment,
        row_number() over (partition by ticket_id order by valid_starting_at desc) as rnk
    from satisfaction_updates
    where field_name = 'satisfaction_comment'
    qualify rnk = 1

),

first_and_latest_score as (
    select
        ticket_id,
        first_value(value) over (partition by ticket_id order by valid_starting_at asc) as first_satisfaction_score,
        first_value(value) over (partition by ticket_id order by valid_starting_at desc) as latest_satisfaction_score,
        row_number() over (partition by ticket_id order by random() desc) as rnk
    from satisfaction_updates
    where field_name = 'satisfaction_score' and value != 'offered'
    qualify rnk = 1

),

satisfaction_scores as (
    select
        ticket_id,
        value,
        case when lag(value) over (partition by ticket_id order by valid_starting_at desc) = 'good' and value = 'bad'
            then 1
            else 0
        end as good_to_bad_score,
        case when lag(value) over (partition by ticket_id order by valid_starting_at desc) = 'bad' and value = 'good'
            then 1
            else 0
        end as bad_to_good_score
    from satisfaction_updates
    where field_name = 'satisfaction_score'

),

score_group as (
    select
        ticket_id,
        count(value) as count_satisfaction_scores,
        sum(good_to_bad_score) as total_good_to_bad_score,
        sum(bad_to_good_score) as total_bad_to_good_score
    from satisfaction_scores
    group by 1

),

final as (
    select
        latest_reason.ticket_id, --PK
        latest_reason.latest_satisfaction_reason,
        latest_comment.latest_satisfaction_comment,
        first_and_latest_score.first_satisfaction_score,
        first_and_latest_score.latest_satisfaction_score,
        case when score_group.count_satisfaction_scores > 0
                then (score_group.count_satisfaction_scores - 1) --Subtracting one as the first score is always "offered".
            else score_group.count_satisfaction_scores
        end as count_satisfaction_scores,
        score_group.total_good_to_bad_score,
        score_group.total_bad_to_good_score,
        score_group.total_good_to_bad_score > 0 as is_good_to_bad_satisfaction_score,
        score_group.total_bad_to_good_score > 0 as is_bad_to_good_satisfaction_score

    from latest_reason

    left join latest_comment
        on latest_reason.ticket_id = latest_comment.ticket_id --one-to-one relationship

    left join first_and_latest_score
        on latest_reason.ticket_id = first_and_latest_score.ticket_id --one-to-one relationship

    left join score_group
        on latest_reason.ticket_id = score_group.ticket_id --one-to-one relationship

)

select *
from final
