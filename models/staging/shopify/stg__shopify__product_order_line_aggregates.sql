with order_lines as (
    select *
    from {{ ref('base__shopify__order_line') }}
),

product_aggregated as (
    select
        product_id,
        source_relation,
        product_globalid,
        count(*) as line_item_count,
        count(distinct order_globalid) as order_count,
        ---
        sum(quantity) as quantity_sold,
        avg(quantity) as avg_quantity_per_order_line,
        ---
        sum(pre_tax_price) as subtotal_sold,
        ---
        sum(total_discount) as product_total_discount,
        avg(total_discount) as product_avg_discount_per_order_line

    from order_lines
    group by 1, 2, 3
)

select *
from product_aggregated
