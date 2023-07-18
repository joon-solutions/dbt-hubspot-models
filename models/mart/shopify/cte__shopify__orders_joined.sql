{{ config(materialized='ephemeral') }}

with order_lines as (

    select *
    from {{ ref('stg__shopify__order_lines') }}

),

orders as (

    select *
    from {{ ref('int__shopify__orders') }}

),

final as (

    select
        date(orders.created_timestamp) as order_date,
    order_lines.sku_globalid,
    order_lines.sku,
    order_lines.source_relation,
    min(date(orders.created_timestamp)) over (partition by order_lines.sku_globalid) as first_order_date,
    coalesce(sum(order_lines.quantity), 0) as quantity,
    coalesce(count(order_lines.order_globalid),0) as order_items_count,
    coalesce(sum(order_lines.price),0) as price_sum
from order_lines
left join orders on order_lines.order_globalid = orders.order_globalid
group by 1, 2, 3, 4

)

select
    *,
    {{ dbt_utils.surrogate_key(['order_date', 'sku_globalid']) }} as id
from final
