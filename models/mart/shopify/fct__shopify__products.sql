with product_aggregated as (

    select *
    from {{ ref('stg__shopify__product_order_line_aggregates') }}

),

products as (

    select *
    from {{ ref('stg__shopify__products') }}
),

final as (
    select
        products.*,
        coalesce(product_aggregated.line_item_count, 0) as line_item_count,
        coalesce(product_aggregated.order_count, 0) as order_count,
        coalesce(product_aggregated.quantity_sold, 0) as total_quantity_sold,
        coalesce(product_aggregated.avg_quantity_per_order_line, 0) as avg_quantity_per_order_line,
        coalesce(product_aggregated.subtotal_sold, 0) as subtotal_sold,
        coalesce(product_aggregated.product_total_discount, 0) as product_total_discount,
        coalesce(product_aggregated.product_avg_discount_per_order_line, 0) as product_avg_discount_per_order_line
    from products
    left join product_aggregated on products.product_globalid = product_aggregated.product_globalid
)

select *
from final
