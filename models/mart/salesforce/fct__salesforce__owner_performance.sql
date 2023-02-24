with opportunity_aggregation_by_owner as (

    select *
    from {{ ref('int__salesforce__agg_by_owner') }}
),

final as (

    select
        opportunity_aggregation_by_owner.*,
        case
            when (opportunity_aggregation_by_owner.bookings_amount_closed_this_month + opportunity_aggregation_by_owner.lost_amount_this_month) > 0
                then opportunity_aggregation_by_owner.bookings_amount_closed_this_month / (opportunity_aggregation_by_owner.bookings_amount_closed_this_month + opportunity_aggregation_by_owner.lost_amount_this_month) * 100
            else 0
        end as win_percent_this_month,
        case
            when (opportunity_aggregation_by_owner.bookings_amount_closed_this_quarter + opportunity_aggregation_by_owner.lost_amount_this_quarter) > 0
                then opportunity_aggregation_by_owner.bookings_amount_closed_this_quarter / (opportunity_aggregation_by_owner.bookings_amount_closed_this_quarter + opportunity_aggregation_by_owner.lost_amount_this_quarter) * 100
            else 0
        end as win_percent_this_quarter,
        case
            when (opportunity_aggregation_by_owner.total_bookings_amount + opportunity_aggregation_by_owner.total_lost_amount) > 0
                then opportunity_aggregation_by_owner.total_bookings_amount / (opportunity_aggregation_by_owner.total_bookings_amount + opportunity_aggregation_by_owner.total_lost_amount) * 100
            else 0
        end as total_win_percent
    from opportunity_aggregation_by_owner
)

select * from final
