with fulfillment as (
    select * from {{ ref('int__shopify__fulfillment') }}
),

orders as (
    select * from {{ ref('int__shopify__orders') }}
),

joined as (
    select
        -- id 
        fulfillment.fulfillment_event_globalid,
        fulfillment.fulfillment_event_id,
        fulfillment.fulfillment_id,
        fulfillment.fulfillment_globalid,
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
        orders.*

    from fulfillment
    left join orders
        on fulfillment.order_globalid = orders.order_globalid -- many to 1 relationship

)

select * from joined
