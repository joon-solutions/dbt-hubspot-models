{{ config(enabled=var('shopify__order_shipping_line', False) and var('shopify__order_shipping_tax_line', False)) }}

with order_shipping_line as (

    select
        order_globalid,
        order_id,
        source_relation,
        order_shipping_line_id,
        sum(price) as shipping_price,
        sum(discounted_price) as discounted_shipping_price
        
    from {{ ref('base__shopify__order_shipping_line') }}
    group by 1,2,3

), 

order_shipping_tax_line as (

    select
        order_shipping_line_globalid,
        order_shipping_line_id,
        source_relation,
        sum(price) as shipping_tax
    from {{ ref('base__shopify__order_shipping_tax_line') }}
    group by 1,2,3

), 

aggregated as (

    select 
        order_shipping_line.order_globalid,
        order_shipping_line.order_id,
        order_shipping_line.source_relation,
        sum(order_shipping_line.shipping_price) as shipping_price,
        sum(order_shipping_line.discounted_shipping_price) as discounted_shipping_price,
        sum(order_shipping_tax_line.shipping_tax) as shipping_tax

    from order_shipping_line
    left join order_shipping_tax_line
        on order_shipping_line.order_shipping_line_globalid = order_shipping_tax_line.order_shipping_line_globalid
        -- and order_shipping_line.source_relation = order_shipping_tax_line.source_relation
    group by 1,2
)

select * from aggregated