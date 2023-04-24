with fulfillment as (
    select
        *,
        case when event_status = 'confirmed' then event_updated_at end as confirmed_at,
        case when event_status = 'delivered' then event_updated_at end as delivered_at,
        case when event_status = 'out_for_delivery' then event_updated_at end as out_for_delivery_at,
        case when event_status = 'ready_for_pickup' then event_updated_at end as ready_for_picked_up_at,
        case when event_status = 'in_transit' then event_updated_at end as transit_at,
        case when event_status = 'delivered' then 1 else 0 end as is_delivered

    from {{ ref('fct__shopify__fulfillment') }}
),

fulfillment_agg as (
    select
        -- pk
        fulfillment_id,
        fulfillment_globalid,
        source_relation,
        order_globalid,
        order_id,
        -- fulfillment 
        city,
        country,
        tracking_company,
        name,
        service,
        shipment_status,
        shipping_address_country,
        shipping_address_latitude,
        shipping_address_longitude,
        -- orders
        coalesce(max(order_value), 0) as order_value,
        coalesce(max(order_refund_value), 0) as order_refund_value,
        coalesce(max(order_total_quantity), 0) as order_total_quantity,
        coalesce(max(order_total_tax), 0) as order_total_tax,
        coalesce(max(order_total_discount), 0) as order_total_discount,
        {% if fivetran_utils.enabled_vars(['shopify__order_shipping_line', 'shopify__order_shipping_tax_line']) %}
        coalesce(max(order_total_shipping),0) as order_total_shipping,
        coalesce(max(order_total_shipping_with_discounts),0) as order_total_shipping_with_discounts,
        coalesce(max(order_total_shipping_tax),0) as order_total_shipping_tax,
        {% endif %}
        -- timestamp
        max(estimated_delivery_at) as estimated_delivery_at,
        max(event_updated_at) as event_updated_at,
        max(confirmed_at) as confirmed_at,
        max(delivered_at) as delivered_at,
        max(out_for_delivery_at) as out_for_delivery_at,
        max(ready_for_picked_up_at) as ready_for_picked_up_at,
        max(transit_at) as transit_at,
        max(is_delivered) as is_delivered

    from fulfillment
    {{ dbt_utils.group_by(n=14) }}
),

final as (
    select
        *,
        timestampdiff(day, confirmed_at, delivered_at) as lead_time,
        timestampdiff(day, ready_for_picked_up_at, delivered_at) as net_lead_time
    from fulfillment_agg
)

select * from final
