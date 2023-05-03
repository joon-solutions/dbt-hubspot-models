{{ config(enabled=var('shopify_enabled', True)) }}

with calendar as (

    select *
    from {{ ref('base__shopify__calendar') }}
    where cast({{ dbt_utils.date_trunc('month','date_day') }} as date) = date_day

),

customers as (

    select *
    from {{ ref('fct__shopify__customers') }}

),

orders as (

    select *
    from {{ ref('fct__shopify__orders') }}

),

customer_calendar as (

    select
        calendar.date_day as date_month,
        customers.customer_id,
        customers.customer_globalid,
        customers.first_order_timestamp,
        customers.source_relation,
        {{ dbt_utils.date_trunc('month', 'first_order_timestamp') }} as cohort_month
    from calendar
    inner join customers
        on cast({{ dbt_utils.date_trunc('month', 'first_order_timestamp') }} as date) <= calendar.date_day

),

orders_joined as (

    select
        customer_calendar.date_month,
        customer_calendar.customer_id,
        customer_calendar.customer_globalid,
        customer_calendar.first_order_timestamp,
        customer_calendar.cohort_month,
        customer_calendar.source_relation,
        coalesce(count(distinct orders.order_id), 0) as total_order_in_month,
        coalesce(sum(orders.order_adjusted_total), 0) as total_order_amount_in_month,
        coalesce(sum(orders.line_item_count), 0) as total_line_item_in_month
    from customer_calendar
    left join orders
        on customer_calendar.customer_globalid = orders.customer_globalid
            -- and customer_calendar.source_relation = orders.source_relation
            and customer_calendar.date_month = cast({{ dbt_utils.date_trunc('month', 'created_timestamp') }} as date)
    {{ dbt_utils.group_by(n=6) }}

),

windows as (

    {% set partition_string = 'partition by customer_id, source_relation order by date_month rows between unbounded preceding and current row' %}

    select
        *,
        sum(total_order_amount_in_month) over ({{ partition_string }}) as total_order_amount_lifetime,
        sum(total_order_in_month) over ({{ partition_string }}) as total_order_lifetime,
        sum(total_line_item_in_month) over ({{ partition_string }}) as total_line_item_lifetime,
        row_number() over (partition by customer_id, source_relation order by date_month asc) as cohort_month_number
    from orders_joined

),

surrogate_key as (

    select
        *,
        {{ dbt_utils.surrogate_key(['date_month','customer_id','source_relation']) }} as customer_cohort_id
    from windows

)

select *
from surrogate_key
