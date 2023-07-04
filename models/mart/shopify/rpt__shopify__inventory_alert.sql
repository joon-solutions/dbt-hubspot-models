with

-- Import CTEs
calendar as (

    select *
    from {{ ref('base__shopify__calendar') }}

),

demand_forecasting as (

    select *
    from {{ ref('fct__shopify__demand_forecasting') }}

),

order_lines as (

    select
        *,
        min(order_date) over (partition by sku) as first_order_date
    from {{ ref('stg__shopify__order_lines') }}

),

inventory_user_input as (

    select *
    from {{ ref('inventory_user_input') }}

),

inventory_level as (

    select * from {{ ref('base__shopify__inventory_level') }}

),

-- Logical CTEs

orders_calendar as (

    select
        calendar.date_day,
        order_lines.sku,
        order_lines.first_order_date
    from calendar
    cross join order_lines

),

order_quantity_calendar as (

    select
        orders_calendar.date_day,
        orders_calendar.sku,
        --coalesce(sum(order_lines.quantity), 0) as actual_sales,
        coalesce(sum(inventory_level.available), 0) as available_inventory -- remaining stock at hand
    from orders_calendar
    left join order_lines on orders_calendar.date_day = order_lines.order_date and orders_calendar.sku = order_lines.sku
    left join inventory_level
        on order_lines.sku = inventory_level.sku and {{ dbt_utils.date_trunc('month','order_lines.order_date') }} = inventory_level.updated_at
    where orders_calendar.date_day >= orders_calendar.first_order_date
    group by 1, 2

),

calendar_month as (

    select
        {{ dbt_utils.date_trunc('month','calendar.date_day') }} as order_month,
        count(distinct calendar.date_day) as days_count
    from calendar
    group by 1

),

-- Final CTE
joins as (

    select
        order_quantity_calendar.*,
        demand_forecasting.forecasted_quantity / calendar_month.days_count as forecasted_daily_sales,
        inventory_user_input.safety_stock,
        inventory_user_input.lead_time
    from order_quantity_calendar
    left join demand_forecasting
        on {{ dbt_utils.date_trunc('month','order_quantity_calendar.date_day') }} = demand_forecasting.order_month
            and order_quantity_calendar.sku = demand_forecasting.sku
    left join calendar_month
        on calendar_month.order_month = demand_forecasting.order_month
    left join inventory_user_input
        on order_quantity_calendar.sku = inventory_user_input.sku

),

final as (

    select
        *,
        forecasted_daily_sales * lead_time + safety_stock as reorder_point,
        coalesce(available_inventory <= forecasted_daily_sales * lead_time + safety_stock, false) as is_reorder_time,
        case
            when available_inventory <= forecasted_daily_sales * lead_time + safety_stock
                then forecasted_daily_sales * lead_time + safety_stock
        end as reorder_quantity
    from joins

)

select * from final
order by 2, 1
