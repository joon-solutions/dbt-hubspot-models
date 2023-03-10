with order_lines as (
    select *
    from {{ ref('base__shopify__order_line') }}
),

order_lines_agg as (
    select
        order_lines.order_id,
        order_lines.source_relation,
        sum(order_lines.quantity) as quantity_sold,
        sum(order_lines.pre_tax_price) as subtotal_sold,
        sum(order_lines.total_discount) as product_total_discount,
        avg(order_lines.quantity) as avg_quantity_per_order_line,
        avg(order_lines.total_discount) as product_avg_discount_per_order_line,
        {{ dbt_utils.surrogate_key(['order_id','source_relation']) }} as unique_id
        
    from order_lines
    group by 1, 2
)

select 
* from order_lines_agg
