with product as (
    select * from {{ ref('base__shopify__product') }}
),

orders as (
    select * from {{ ref('int__shopify__orders') }}
),

joined as (
    select
        orders.order_globalid,
        orders.customer_globalid,
        orders.closed_timestamp,
        product.product_globalid,
        product.handle,
        product.product_type,
        product.title,
        product.vendor,
        product.status
    from product
    inner join orders on product.product_globalid = orders.product_globalid
),

basket as (
    select
        product_a.product_globalid as product_a_globalid,
        product_a.handle as product_a_handle,
        product_a.product_type as product_a_type,
        product_a.title as product_a_title,
        product_a.vendor as product_a_vendor,
        product_a.status as product_a_status,
        product_b.product_globalid as product_b_globalid,
        product_b.handle as product_b_handle,
        product_b.product_type as product_b_type,
        product_b.title as product_b_title,
        product_b.vendor as product_b_vendor,
        product_b.status as product_b_status,
        count(*) as frequency
    from joined as product_a
    inner join joined as product_b on product_a.customer_globalid = product_b.customer_globalid
        and product_a.closed_timestamp = product_b.closed_timestamp
    {{ dbt_utils.group_by(n=12) }}
    order by 13 desc
)

select
    *,
    {{ dbt_utils.surrogate_key(['product_a_globalid','product_b_globalid']) }} as basket_id
from basket
