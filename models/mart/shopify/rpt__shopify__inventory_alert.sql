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

inventory_user_input as (

    select *
    from {{ ref('base__shopify__inventory_user_input') }}

),

inventory_level as (

    select * from {{ ref('base__shopify__inventory_level') }}

),

-- Logical CTEs

inventory_level_calendar as (

    select
        calendar.date_day,
        inventory_level.sku,
        inventory_level.sku_globalid,
        inventory_level.source_relation
    from calendar
    cross join inventory_level

),

inventory_joins as (

    select
        inventory_level_calendar.date_day,
        inventory_level_calendar.sku,
        inventory_level_calendar.source_relation,
        inventory_level_calendar.sku_globalid,
        coalesce(sum(inventory_level.available), 0) as available_inventory -- remaining stock at hand
    from inventory_level_calendar
    left join inventory_level
        on inventory_level_calendar.sku_globalid = inventory_level.sku_globalid and {{ dbt_utils.date_trunc('month','inventory_level_calendar.date_day') }} = inventory_level.updated_at
    group by 1, 2, 3, 4

),

-- Final CTE
joins as (

    select
        inventory_joins.*,
        count(distinct inventory_joins.date_day) over (partition by {{ dbt_utils.date_trunc('month','inventory_joins.date_day') }}) as days_count,
        demand_forecasting.forecasted_quantity / count(distinct inventory_joins.date_day) over (partition by {{ dbt_utils.date_trunc('month','inventory_joins.date_day') }}) as forecasted_daily_sales,
        inventory_user_input.safety_stock,
        inventory_user_input.lead_time
    from inventory_joins
    left join demand_forecasting
        on {{ dbt_utils.date_trunc('month','inventory_joins.date_day') }} = demand_forecasting.order_month
            and inventory_joins.sku_globalid = demand_forecasting.sku_globalid
    left join inventory_user_input
        on inventory_joins.sku = inventory_user_input.sku
            and inventory_joins.source_relation = inventory_user_input.source_relation
    where inventory_joins.date_day >= demand_forecasting.first_order_date

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
