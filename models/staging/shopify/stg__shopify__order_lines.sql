with order_lines as (
    select *
    from {{ ref('base__shopify__order_line') }}
),

tax_aggregates as (
    select
        order_line_globalid,
        order_line_id,
        source_relation,
        sum(price) as price
    from {{ ref('base__shopify__tax_line') }}
    group by 1, 2, 3
),

product_variants as (

    select *
    from {{ ref('base__shopify__product_variant') }}

),

final as (
    select
        order_lines.order_line_globalid,
        order_lines.order_line_id,
        coalesce(order_lines.sku, 'URBD0001') as sku, -- 'URBD0001' is used to fill in missing skus in dummy data, making demand forecasting per sku less noisy.
        order_lines.order_id,
        order_lines.source_relation,
        order_lines.order_globalid,
        order_lines.product_id,
        order_lines.product_globalid,
        order_lines.product_variant_globalid,
        concat(
            order_lines.origin_location_city, ', ',
            order_lines.origin_location_country_code, ' - ',
            order_lines.destination_location_city, ', ',
            order_lines.destination_location_country_code
        ) as order_route,
        order_lines.price,
        order_lines.total_discount,
        order_lines.quantity,
        order_lines.pre_tax_price,
        order_lines.price * order_lines.quantity as gross_revenue,
        tax_aggregates.price as order_line_tax,
        product_variants.compare_at_price as variant_compare_at_price,
        product_variants.price as variant_price,
        product_variants.sku as variant_sku,
        {{ dbt_utils.surrogate_key(['order_lines.sku','order_lines.source_relation']) }} as sku_globalid

    from order_lines
    left join tax_aggregates
        on tax_aggregates.order_line_globalid = order_lines.order_line_globalid
    left join product_variants
        on product_variants.product_variant_globalid = order_lines.product_variant_globalid

)

select *
from final
