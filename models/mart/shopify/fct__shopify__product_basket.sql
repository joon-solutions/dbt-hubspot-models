with product as (
    select * from {{ ref('int__shopify__products_order_line') }}
),

--to get orders attributes
orders as (
    select * from {{ ref('int__shopify__orders') }}
),

basket as (
    select
        order_globalid,
        listagg(distinct product_globalid, ',') as products_list,
        listagg(distinct tags, ',') as product_tag_list,
        listagg(distinct product_type, ',') as products_type_list,
        listagg(distinct handle, ',') as products_handle_list,
        listagg(distinct title, ',') as products_title_list
    from product
    group by 1
),

final as (
    select
        orders.*, ---in BI layer we can pivot by order times/ order amounts/ or other order attributes to dig further into each product combo performance
        basket.products_list,
        basket.product_tag_list,
        basket.products_type_list,
        basket.products_handle_list,
        basket.products_title_list
    from basket
    left join orders on basket.order_globalid = orders.order_globalid --one-to-one
)

select *
from final
