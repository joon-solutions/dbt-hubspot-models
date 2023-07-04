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

orders as (

    select *
    from {{ ref('base__shopify__orders') }}

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
        concat(
            order_lines.origin_location_city, ', ',
            order_lines.origin_location_country_code, ' - ',
            order_lines.destination_location_city, ', ',
            order_lines.destination_location_country_code
        ) as order_route,
        order_lines.total_discount,
        order_lines.quantity,
        order_lines.pre_tax_price,
        tax_aggregates.price as order_line_tax,
        {{ dbt_utils.date_trunc('day','orders.created_timestamp') }} as order_date,
        {{ dbt_utils.date_trunc('month','orders.created_timestamp') }} as order_month

    from order_lines
    left join tax_aggregates
        on tax_aggregates.order_line_globalid = order_lines.order_line_globalid
    left join orders
        on order_lines.order_id = orders.order_id

)

select *
from final
