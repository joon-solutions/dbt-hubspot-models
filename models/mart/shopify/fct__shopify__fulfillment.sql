with fulfillment as (
    select * from {{ ref('int__shopify__fulfillment') }}
),

orders as (
    select * from {{ ref('int__shopify__orders') }}
),

joined as (
    select
        --pk
        fulfillment.fulfillment_event_globalid,
        fulfillment.fulfillment_event_id,
        fulfillment.source_relation,
        -- fulfillment
        fulfillment.event_status,
        fulfillment.city,
        fulfillment.country,
        fulfillment.tracking_company,
        fulfillment.name,
        fulfillment.service,
        fulfillment.shipment_status,
        fulfillment.estimated_delivery_at,
        fulfillment.event_updated_at,
        -- order 
        {% if fivetran_utils.enabled_vars(['shopify__order_shipping_line', 'shopify__order_shipping_tax_line']) %}
        orders.order_total_shipping,
        {% endif %}
        orders.created_timestamp,
        orders.order_globalid,
        orders.order_id,
        orders.order_value,
        orders.order_refund_value,
        orders.order_total_quantity,
        orders.order_total_tax,
        orders.order_total_discount,
        orders.shipping_address_country,
        orders.shipping_address_latitude,
        orders.shipping_address_longitude,
        orders.total_shipping_price_set

    from fulfillment
    left join orders
        on fulfillment.order_globalid = orders.order_globalid -- many to 1 relationship
-- and fulfillment.source_relation = orders.source_relation
)

select * from joined
