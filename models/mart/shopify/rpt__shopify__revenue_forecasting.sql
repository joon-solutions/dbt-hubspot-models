with order_lines as (

    select *
    from {{ ref('stg__shopify__order_lines') }}

),

orders as (

    select *
    from {{ ref('int__shopify__orders') }}

),

orders_joined as (

    select
        {{ dbt_utils.date_trunc('month','orders.created_timestamp') }} as order_month,
        order_lines.sku_globalid,
        order_lines.sku,
        sum(order_lines.gross_revenue) as gross_revenue
    from order_lines
    left join orders on order_lines.order_globalid = orders.order_globalid
    group by 1, 2, 3

),

sku_variants as (

    select distinct
        order_lines.sku_globalid,
        order_lines.variant_price
    from order_lines

),

sku_variants_price as (

    select
        sku_globalid,
        avg(variant_price) as avg_unit_price
    from sku_variants
    group by 1

),

demand_forecasting as (

    select *
    from {{ ref('fct__shopify__demand_forecasting') }}

),

revenue_forecasting as (

    select
        demand_forecasting.id,
        demand_forecasting.order_month,
        demand_forecasting.sku,
        demand_forecasting.sku_globalid,
        demand_forecasting.forecasted_quantity,
        coalesce(orders_joined.gross_revenue, 0) as actual_gross_revenue,
        sku_variants_price.avg_unit_price,
        demand_forecasting.forecasted_quantity * sku_variants_price.avg_unit_price as forecasted_gross_revenue
    from demand_forecasting
    left join orders_joined
        on demand_forecasting.sku_globalid = orders_joined.sku_globalid
            and demand_forecasting.order_month = orders_joined.order_month
    left join sku_variants_price
        on demand_forecasting.sku_globalid = sku_variants_price.sku_globalid

),

final as (

    select
        *,
        case
            when revenue_forecasting.order_month < {{ dbt_utils.date_trunc('month','current_date') }}
                then revenue_forecasting.actual_gross_revenue
            else revenue_forecasting.forecasted_gross_revenue end as gross_revenue_concat,
        case
            when revenue_forecasting.order_month < {{ dbt_utils.date_trunc('month','current_date') }}
                then revenue_forecasting.actual_gross_revenue
        end as actual_gross_revenue_limit,
        case
            when revenue_forecasting.order_month < {{ dbt_utils.date_trunc('month','current_date') }}
                then null
            else revenue_forecasting.forecasted_gross_revenue
        end as forecasted_gross_revenue_limit
    from revenue_forecasting

)

select *
from final
