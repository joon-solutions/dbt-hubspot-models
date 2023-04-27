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

order_lines_agg as (
    select
        -- order_lines.order_line_globalid,
        -- order_lines.order_line_id,
        order_lines.order_id,
        order_lines.source_relation,
        order_lines.order_globalid,
        max(
            concat(
                order_lines.origin_location_city, ', ',
                order_lines.origin_location_country_code, ' - ',
                order_lines.destination_location_city, ', ',
                order_lines.destination_location_country_code
            )
        ) as order_route,
        count(*) as line_item_count,
        sum(order_lines.quantity) as order_total_quantity,
        -- sum(order_lines.pre_tax_price) as ,
        sum(order_lines.total_discount) as order_total_discount,
        -- avg(order_lines.quantity) as avg_quantity_per_order_line,
        -- avg(order_lines.total_discount) as product_avg_discount_per_order_line,
        sum(tax_aggregates.price) as order_total_tax
    from order_lines
    left join tax_aggregates
        on tax_aggregates.order_line_globalid = order_lines.order_line_globalid
    -- and tax_aggregates.source_relation = order_lines.source_relation
    {{ dbt_utils.group_by(n=3) }}
)

select *
from order_lines_agg
