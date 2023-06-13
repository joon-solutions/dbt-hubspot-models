{{ config(enabled=var('salesforce__opportunity_enabled', False)) }}

with opportunity_agg_by_owner as (

    select *
    from {{ ref('int__salesforce__agg_by_owner') }}
),


final as (

    select
        coalesce(cast(manager_id as string), 'No Manager Assigned') as manager_id,
        coalesce(manager_name, 'No Manager Assigned') as manager_name,
        manager_city,
        manager_state,
        -- aggregations
        count(distinct owner_id) as number_of_direct_reports,
        coalesce(sum(bookings_amount_closed_this_month), 0) as bookings_amount_closed_this_month,
        coalesce(sum(bookings_amount_closed_this_quarter), 0) as bookings_amount_closed_this_quarter,
        coalesce(sum(total_number_bookings), 0) as total_number_bookings,
        coalesce(sum(total_bookings_amount), 0) as total_bookings_amount,
        coalesce(sum(bookings_count_closed_this_month), 0) as bookings_count_closed_this_month,
        coalesce(sum(bookings_count_closed_this_quarter), 0) as bookings_count_closed_this_quarter,
        coalesce(max(largest_booking), 0) as largest_booking,
        coalesce(sum(lost_amount_this_month), 0) as lost_amount_this_month,
        coalesce(sum(lost_amount_this_quarter), 0) as lost_amount_this_quarter,
        coalesce(sum(total_number_lost), 0) as total_number_lost,
        coalesce(sum(total_lost_amount), 0) as total_lost_amount,
        coalesce(sum(lost_count_this_month), 0) as lost_count_this_month,
        coalesce(sum(lost_count_this_quarter), 0) as lost_count_this_quarter,
        coalesce(sum(pipeline_created_amount_this_month), 0) as pipeline_created_amount_this_month,
        coalesce(sum(pipeline_created_amount_this_quarter), 0) as pipeline_created_amount_this_quarter,
        coalesce(sum(pipeline_created_forecast_amount_this_month), 0) as pipeline_created_forecast_amount_this_month,
        coalesce(sum(pipeline_created_forecast_amount_this_quarter), 0) as pipeline_created_forecast_amount_this_quarter,
        coalesce(sum(pipeline_count_created_this_month), 0) as pipeline_count_created_this_month,
        coalesce(sum(pipeline_count_created_this_quarter), 0) as pipeline_count_created_this_quarter,
        coalesce(sum(total_number_pipeline), 0) as total_number_pipeline,
        coalesce(sum(total_pipeline_amount), 0) as total_pipeline_amount,
        coalesce(sum(total_pipeline_forecast_amount), 0) as total_pipeline_forecast_amount,
        coalesce(max(largest_deal_in_pipeline), 0) as largest_deal_in_pipeline,
        round(case
            when sum(bookings_amount_closed_this_month + lost_amount_this_month) > 0 then
                sum(bookings_amount_closed_this_month) / sum(bookings_amount_closed_this_month + lost_amount_this_month) * 100
            else 0
            end, 2) as win_percent_this_month,
        round(case
            when sum(bookings_amount_closed_this_quarter + lost_amount_this_quarter) > 0 then
                sum(bookings_amount_closed_this_quarter) / sum(bookings_amount_closed_this_quarter + lost_amount_this_quarter) * 100
            else 0
            end, 2) as win_percent_this_quarter,
        round(case
            when sum(total_bookings_amount + total_lost_amount) > 0 then
                sum(total_bookings_amount) / sum(total_bookings_amount + total_lost_amount) * 100
            else 0
            end, 2) as total_win_percent

    from opportunity_agg_by_owner
    group by 1, 2, 3, 4
    having count(distinct owner_id) > 0
)

select * from final
