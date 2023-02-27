with opportunity as (

    select *
    from {{ ref('stg__salesforce__opportunity') }}
),

users as (
    select 
        opportunity_owner_id,
        opportunity_owner_name,
        opportunity_owner_city,
        opportunity_owner_state

    from opportunity
    group by 1,2,3,4
),

booking_by_owner as (

    select
        opportunity_manager_id as b_manager_id,
        opportunity_owner_id as b_owner_id,
        round(sum(closed_amount_this_month)) as bookings_amount_closed_this_month,
        round(sum(closed_amount_this_quarter)) as bookings_amount_closed_this_quarter,
        count(*) as total_number_bookings,
        round(sum(amount)) as total_bookings_amount,
        sum(closed_count_this_month) as bookings_count_closed_this_month,
        sum(closed_count_this_quarter) as bookings_count_closed_this_quarter,
        round(avg(amount)) as avg_bookings_amount,
        max(amount) as largest_booking,
        avg(days_to_close) as avg_days_to_close
    from opportunity
    where opportunity_status = 'Won'
    group by 1, 2
),

lost_by_owner as (

    select
        opportunity_manager_id as l_manager_id,
        opportunity_owner_id as l_owner_id,
        round(sum(closed_amount_this_month)) as lost_amount_this_month,
        round(sum(closed_amount_this_quarter)) as lost_amount_this_quarter,
        count(*) as total_number_lost,
        round(sum(amount)) as total_lost_amount,
        sum(closed_count_this_month) as lost_count_this_month,
        sum(closed_count_this_quarter) as lost_count_this_quarter
    from opportunity
    where opportunity_status = 'Lost'
    group by 1, 2
),

pipeline_by_owner as (

    select
        opportunity_manager_id as p_manager_id,
        opportunity_owner_id as p_owner_id,
        round(sum(created_amount_this_month)) as pipeline_created_amount_this_month,
        round(sum(created_amount_this_quarter)) as pipeline_created_amount_this_quarter,
        round(sum(created_amount_this_month * opportunity_probability)) as pipeline_created_forecast_amount_this_month,
        round(sum(created_amount_this_quarter * opportunity_probability)) as pipeline_created_forecast_amount_this_quarter,
        sum(created_count_this_month) as pipeline_count_created_this_month,
        sum(created_count_this_quarter) as pipeline_count_created_this_quarter,
        count(*) as total_number_pipeline,
        round(sum(amount)) as total_pipeline_amount,
        round(sum(amount * opportunity_probability)) as total_pipeline_forecast_amount,
        round(avg(amount)) as avg_pipeline_opp_amount,
        max(amount) as largest_deal_in_pipeline,
        avg(days_since_created) as avg_days_open
    from opportunity
    where opportunity_status = 'Pipeline'
    group by 1, 2
)

select
    users.*,
    coalesce(pipeline_by_owner.p_manager_id, booking_by_owner.b_manager_id, lost_by_owner.l_manager_id) as manager_id,
    booking_by_owner.*,
    lost_by_owner.*,
    pipeline_by_owner.*
from users
left join booking_by_owner
    on booking_by_owner.b_owner_id = users.opportunity_owner_id
left join lost_by_owner
    on lost_by_owner.l_owner_id = users.opportunity_owner_id
left join pipeline_by_owner
    on pipeline_by_owner.p_owner_id = users.opportunity_owner_id
