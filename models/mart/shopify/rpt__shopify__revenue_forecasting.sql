with orders_joined as (

    select *
    from {{ ref('cte__shopify__orders_joined') }}

),

demand_forecasting as (

    select *
    from {{ ref('fct__shopify__demand_forecasting') }}

),

recent_orders as (

    select
        orders_joined.sku_globalid,
        orders_joined.sku,
        coalesce(sum(orders_joined.order_items_count),0) as order_items_count,
        coalesce(sum(orders_joined.price_sum),0) as price_sum,
        coalesce(div0(sum(orders_joined.price_sum),sum(orders_joined.order_items_count)),0) as avg_price_per_item
    from orders_joined
    where {{ dbt_utils.date_trunc('month','orders_joined.order_date') }} = {{ dbt_utils.date_trunc('month','orders_joined.first_order_date') }} -- mapping with first_order_date for better visualization
    --{{ dbt_utils.date_trunc('month','current_date') }}
    group by 1,2

),

final as (

    select
        demand_forecasting.id,
        demand_forecasting.order_month,
        demand_forecasting.sku,
        demand_forecasting.sku_globalid,
        demand_forecasting.forecasted_quantity,
        recent_orders.avg_price_per_item,
        demand_forecasting.forecasted_quantity * recent_orders.avg_price_per_item as forecasted_revenue
    from demand_forecasting
    left join recent_orders 
        on demand_forecasting.sku_globalid = recent_orders.sku_globalid

)

select *
from final