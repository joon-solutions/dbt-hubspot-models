{{ config(enabled=var('shopify_enabled', False)) }}
with products as (
    select *
    from {{ ref('int__shopify__products_order_line') }}

),

--to get orders attributes
orders as (
    select *
    from {{ ref('int__shopify__orders') }}
),

final as (
    select
        products.product_globalid,
        products.product_id,
        products.handle,
        products.product_type,
        products.title,
        products.vendor,
        products.status,
        products.published_scope,
        products.created_timestamp,
        products.collections,
        products.tags,
        products.count_variants,
        products.has_product_image,
        count(*) as line_item_count,
        count(distinct products.order_globalid) as order_count,
        ---
        sum(products.order_line_quantity) as total_quantity_sold,
        avg(products.order_line_quantity) as avg_quantity_per_order_line,
        ---
        sum(products.order_line_pre_tax_price) as subtotal_sold,
        ---
        sum(products.order_line_discount) as product_total_discount,
        avg(products.order_line_discount) as product_avg_discount_per_order_line,
        ---
        sum(products.order_line_tax) as product_total_tax,
        avg(products.order_line_tax) as product_avg_tax_per_order_line,
        ---
        ---
        sum(orders.order_value) as total_order_value,
        ---
        sum(orders.order_refund_value) as total_order_refund_value,
        min(orders.created_timestamp) as first_order_timestamp,
        max(orders.created_timestamp) as most_recent_order_timestamp
    from products
    left join orders on products.order_globalid = orders.order_globalid --many-to-one
    {{ dbt_utils.group_by(n=13) }}
)

select *
from final
