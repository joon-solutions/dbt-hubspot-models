with calendar as (

    select *
    from {{ ref('base__shopify__calendar') }}
    where cast({{ dbt_utils.date_trunc('month','date_day') }} as date) = date_day

),

order_lines as (

    select *
    from {{ ref('fct__shopify__order_lines') }}

),

orders as (

    select *
    from {{ ref('fct__shopify__orders') }}

),

orders_joined as (
    select
        {{ dbt_utils.date_trunc('month','created_timestamp') }} as order_month,
        order_lines.sku,
        min({{ dbt_utils.date_trunc('month','created_timestamp') }}) over (partition by order_lines.sku) as min_order_month,
        --max({{ dbt_utils.date_trunc('month','created_timestamp') }}) over (partition by order_lines.sku) as max_order_month,
        coalesce(sum(order_lines.quantity), 0) as quantity
    from order_lines
    left join orders on order_lines.order_globalid = orders.order_globalid
    group by 1, 2

),

order_lines_calendar as (

    select distinct
        calendar.date_day,
        orders_joined.sku,
        orders_joined.min_order_month
        --orders_joined.max_order_month
    from calendar
    cross join orders_joined

),

orders_calendar as (

    select
        order_lines_calendar.date_day as order_month,
        order_lines_calendar.sku,
        row_number() over (partition by order_lines_calendar.sku order by order_lines_calendar.date_day asc) as forecast_key,
        coalesce(orders_joined.quantity, 0) as quantity
    from order_lines_calendar
    left join orders_joined on order_lines_calendar.date_day = orders_joined.order_month
        and order_lines_calendar.sku = orders_joined.sku
    --where order_lines_calendar.date_day between order_lines_calendar.min_order_month and order_lines_calendar.max_order_month
    where order_lines_calendar.date_day >= order_lines_calendar.min_order_month

),

regr as (
    select
        sku,
        regr_slope(quantity, forecast_key) as slope,
        regr_intercept(quantity, forecast_key) as intercept
    from orders_calendar
    group by 1

),

final as (
    select
        orders_calendar.order_month,
        orders_calendar.sku,
        orders_calendar.quantity,
        orders_calendar.forecast_key,
        orders_calendar.forecast_key * regr.slope + regr.intercept as forecasted_quantity
    from orders_calendar
    left join regr on orders_calendar.sku = regr.sku

)

select
    *,
    {{ dbt_utils.surrogate_key(['order_month', 'sku']) }} as id
from final
order by 2, 1
