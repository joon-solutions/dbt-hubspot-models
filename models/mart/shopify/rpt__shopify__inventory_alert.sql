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
        min(order_date) over (partition by sku_globalid) as first_order_date
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
        order_lines.sku_globalid,
        order_lines.source_relation,
        order_lines.first_order_date
    from calendar
    cross join order_lines

),

order_inventory_calendar as (

    select
        orders_calendar.date_day,
        orders_calendar.sku,
        orders_calendar.source_relation,
        orders_calendar.sku_globalid,
        coalesce(sum(inventory_level.available), 0) as available_inventory -- remaining stock at hand
    from orders_calendar
    left join inventory_level
        on orders_calendar.sku_globalid = inventory_level.sku_globalid and {{ dbt_utils.date_trunc('month','orders_calendar.date_day') }} = inventory_level.updated_at
    where orders_calendar.date_day >= orders_calendar.first_order_date
    group by 1, 2, 3, 4

),

-- Final CTE
joins as (

    select
        order_inventory_calendar.*,
        count(distinct order_inventory_calendar.date_day) over (partition by {{ dbt_utils.date_trunc('month','order_inventory_calendar.date_day') }}) as days_count,
        demand_forecasting.forecasted_quantity / count(distinct order_inventory_calendar.date_day) over (partition by {{ dbt_utils.date_trunc('month','order_inventory_calendar.date_day') }}) as forecasted_daily_sales,
        inventory_user_input.safety_stock,
        inventory_user_input.lead_time
    from order_inventory_calendar
    left join demand_forecasting
        on {{ dbt_utils.date_trunc('month','order_inventory_calendar.date_day') }} = demand_forecasting.order_month
            and order_inventory_calendar.sku_globalid = demand_forecasting.sku_globalid
    left join inventory_user_input
        on order_inventory_calendar.sku = inventory_user_input.sku
            and order_inventory_calendar.source_relation = inventory_user_input.source_relation

),

final as (

    select
        *,
        available_inventory / forecasted_daily_sales as days_stock_covered,
        forecasted_daily_sales * lead_time + safety_stock as reorder_point,
        coalesce(available_inventory <= forecasted_daily_sales * lead_time + safety_stock, false) as is_reorder_time,
        case
            when available_inventory <= forecasted_daily_sales * lead_time + safety_stock
                then forecasted_daily_sales * lead_time + safety_stock
        end as reorder_quantity
    from joins

)

select
    *,
    {{ dbt_utils.surrogate_key(['sku_globalid','date_day']) }} as id
from final
order by 2, 1
