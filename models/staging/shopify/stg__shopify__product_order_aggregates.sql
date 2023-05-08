with orders as (

    select *
    from {{ ref('base__shopify__orders') }}

),

order_lines as (

    select *
    from {{ ref('base__shopify__order_line') }}

),

joined as (
    select
        orders.*,
        ---order_line metrics
        order_lines.product_id,
        order_lines.product_globalid
    from orders
    left join order_lines
        on orders.order_globalid = order_lines.order_globalid
)

select 
    *,
    {{ dbt_utils.surrogate_key(['product_globalid','order_globalid']) }} as unique_id
from joined
