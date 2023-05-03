{{ config(enabled=var('salesforce__opportunity_enabled', True)) }}

with opportunity as (

    select *
    from {{ ref('stg__salesforce__opportunity') }}
),

booking_by_owner as (

    select
        -- owner
        opportunity_owner_id as b_owner_id,
        opportunity_owner_name as b_owner_name,
        opportunity_owner_city as b_owner_city,
        opportunity_owner_state as b_owner_state,
        -- manager
        opportunity_manager_id as b_manager_id,
        opportunity_manager_name as b_manager_name,
        opportunity_manager_city as b_manager_city,
        opportunity_manager_state as b_manager_state,
        -- aggregations
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
    {{ dbt_utils.group_by(n=8) }}
),

lost_by_owner as (

    select
        -- owner
        opportunity_owner_id as l_owner_id,
        opportunity_owner_name as l_owner_name,
        opportunity_owner_city as l_owner_city,
        opportunity_owner_state as l_owner_state,
        -- manager
        opportunity_manager_id as l_manager_id,
        opportunity_manager_name as l_manager_name,
        opportunity_manager_city as l_manager_city,
        opportunity_manager_state as l_manager_state,
        -- aggregations
        round(sum(closed_amount_this_month)) as lost_amount_this_month,
        round(sum(closed_amount_this_quarter)) as lost_amount_this_quarter,
        count(*) as total_number_lost,
        round(sum(amount)) as total_lost_amount,
        sum(closed_count_this_month) as lost_count_this_month,
        sum(closed_count_this_quarter) as lost_count_this_quarter
    from opportunity
    where opportunity_status = 'Lost'
    {{ dbt_utils.group_by(n=8) }}
),

pipeline_by_owner as (

    select
        -- owner
        opportunity_owner_id as p_owner_id,
        opportunity_owner_name as p_owner_name,
        opportunity_owner_city as p_owner_city,
        opportunity_owner_state as p_owner_state,
        -- manager
        opportunity_manager_id as p_manager_id,
        opportunity_manager_name as p_manager_name,
        opportunity_manager_city as p_manager_city,
        opportunity_manager_state as p_manager_state,
        -- aggregations
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
    {{ dbt_utils.group_by(n=8) }}
)

select
    -- owner
    coalesce(pipeline_by_owner.p_owner_id, booking_by_owner.b_owner_id, lost_by_owner.l_owner_id) as owner_id,
    coalesce(pipeline_by_owner.p_owner_name, booking_by_owner.b_owner_name, lost_by_owner.l_owner_name) as owner_name,
    coalesce(pipeline_by_owner.p_owner_city, booking_by_owner.b_owner_city, lost_by_owner.l_owner_city) as owner_city,
    coalesce(pipeline_by_owner.p_owner_state, booking_by_owner.b_owner_state, lost_by_owner.l_owner_state) as owner_state,
    -- manager
    coalesce(pipeline_by_owner.p_manager_id, booking_by_owner.b_manager_id, lost_by_owner.l_manager_id) as manager_id,
    coalesce(pipeline_by_owner.p_manager_name, booking_by_owner.b_manager_name, lost_by_owner.l_manager_name) as manager_name,
    coalesce(pipeline_by_owner.p_manager_city, booking_by_owner.b_manager_city, lost_by_owner.l_manager_city) as manager_city,
    coalesce(pipeline_by_owner.p_manager_state, booking_by_owner.b_manager_state, lost_by_owner.l_manager_state) as manager_state,
    -- aggregations
    booking_by_owner.*,
    lost_by_owner.*,
    pipeline_by_owner.*
from booking_by_owner
full outer join lost_by_owner
    on lost_by_owner.l_owner_id = booking_by_owner.b_owner_id
full outer join pipeline_by_owner
    on pipeline_by_owner.p_owner_id = booking_by_owner.b_owner_id
