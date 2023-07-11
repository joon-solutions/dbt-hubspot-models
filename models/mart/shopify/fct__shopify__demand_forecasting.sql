with calendar as (

    select *
    from {{ ref('base__shopify__calendar_forecasting') }}
    where cast({{ dbt_utils.date_trunc('month','date_day') }} as date) = date_day

),

order_lines as (

    select *
    from {{ ref('stg__shopify__order_lines') }}

),

orders as (

    select *
    from {{ ref('int__shopify__orders') }}

),

orders_joined as (
    select
        date(orders.created_timestamp) as order_date,
        order_lines.sku_globalid,
        order_lines.sku,
        order_lines.source_relation,
        min(date(orders.created_timestamp)) over (partition by order_lines.sku_globalid) as first_order_date,
        coalesce(sum(order_lines.quantity), 0) as quantity
    from order_lines
    left join orders on order_lines.order_globalid = orders.order_globalid
    group by 1, 2, 3, 4

),

order_lines_calendar as (

    select distinct
        calendar.date_day,
        orders_joined.sku,
        orders_joined.sku_globalid,
        orders_joined.source_relation,
        orders_joined.first_order_date
    from calendar
    cross join orders_joined

),

orders_calendar as (

    select
        order_lines_calendar.date_day as order_month,
        order_lines_calendar.sku,
        order_lines_calendar.sku_globalid,
        order_lines_calendar.source_relation,
        order_lines_calendar.first_order_date,
        row_number() over (partition by order_lines_calendar.sku_globalid order by order_lines_calendar.date_day asc) as forecast_key,
        coalesce(sum(orders_joined.quantity), 0) as quantity
    from order_lines_calendar
    left join orders_joined on order_lines_calendar.date_day = {{ dbt_utils.date_trunc('month','orders_joined.order_date') }}
        and order_lines_calendar.sku_globalid = orders_joined.sku_globalid
    where order_lines_calendar.date_day >= {{ dbt_utils.date_trunc('month','order_lines_calendar.first_order_date') }}
    {{ dbt_utils.group_by(5) }}

),

regr as (
    select
        sku_globalid,
        sku,
        source_relation,
        regr_slope(quantity, forecast_key) as slope,
        regr_intercept(quantity, forecast_key) as intercept
    from orders_calendar
    where order_month < {{ dbt_utils.date_trunc('month','current_date') }}
    group by 1, 2, 3

),

final as (
    select
        orders_calendar.order_month,
        orders_calendar.sku,
        orders_calendar.sku_globalid,
        orders_calendar.source_relation,
        orders_calendar.quantity,
        orders_calendar.forecast_key,
        orders_calendar.first_order_date,
        regr.slope,
        regr.intercept,
        orders_calendar.forecast_key * regr.slope + regr.intercept as forecasted_quantity
    from orders_calendar
    left join regr on orders_calendar.sku_globalid = regr.sku_globalid

)

select
    *,
    {{ dbt_utils.surrogate_key(['order_month', 'sku_globalid']) }} as id
from final
order by 2, 1
