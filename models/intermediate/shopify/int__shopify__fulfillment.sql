with fulfillment as (
    select * from {{ ref('base__shopify__fulfillment') }}
),

fulfillment_event as (
    select * from {{ ref('base__shopify__fulfillment_event') }}

),

joined as (

    select
        -- id
        fulfillment_event.unique_id,
        fulfillment_event.source_relation,
        fulfillment_event.fulfillment_event_id,
        fulfillment_event.fulfillment_id,
        fulfillment_event.order_id,
        fulfillment_event.shop_id,
        -- address
        fulfillment_event.address_1,
        fulfillment_event.city,
        fulfillment_event.country,
        fulfillment_event.latitude,
        fulfillment_event.longitude,
        --status
        fulfillment_event.event_status,
        fulfillment.tracking_company,
        fulfillment.name,
        fulfillment.service,
        fulfillment.shipment_status,
        fulfillment.status,
        --timestamp
        fulfillment_event.estimated_delivery_at,
        fulfillment_event.event_happened_at,
        fulfillment_event.event_created_at,
        fulfillment_event.event_updated_at,
        fulfillment.created_at,
        fulfillment.updated_at
    from fulfillment_event
    left join fulfillment
        on fulfillment_event.fulfillment_id = fulfillment.fulfillment_id
)

select * from joined
