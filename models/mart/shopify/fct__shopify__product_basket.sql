with product as (
    select * from {{ ref('base__shopify__product') }}
),

orders as (
    select * from {{ ref('stg__shopify__product_order_aggregates') }}
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
    from orders
    inner join product on product.product_globalid = orders.product_globalid
),

basket as (
    select
        concat(product_globalid, ',') as products_list,
        concat(product_type) as products_type_list,
        concat(handle) as products_handle_list,
        concat(title) as products_title_list,
        count(*) as frequency

    from joined
    group by product_globalid, product_type, handle, title
    order by frequency desc
)

select
    *,
    {{ dbt_utils.surrogate_key(['products_list','frequency']) }} as basket_id
from basket
