{{ config(enabled=var('shopify_enabled', False)) }}
with order_lines as (

    select *
    from {{ ref('stg__shopify__order_lines') }}

),

products as (
    select *
    from {{ ref('stg__shopify__products') }}
),

final as (
    select
        products.*,
        order_lines.order_line_globalid,
        order_lines.order_globalid,
        order_lines.order_route,
        order_lines.total_discount as order_line_discount,
        order_lines.quantity as order_line_quantity,
        order_lines.pre_tax_price as order_line_pre_tax_price,
        order_lines.order_line_tax
    from products
    left join order_lines on products.product_globalid = order_lines.product_globalid --one-to-many
)

select
    *,
    {{ dbt_utils.surrogate_key(['order_line_globalid','product_globalid']) }} as id
from final
