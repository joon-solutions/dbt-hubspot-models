with fulfillment as (
    select
        *,
        case when event_status = 'confirmed' then event_updated_at end as confirmed_at,
        case when event_status = 'delivered' then event_updated_at end as delivered_at,
        case when event_status = 'out_for_delivery' then event_updated_at end as out_for_delivery_at,
        case when event_status = 'delivered' then 1 else 0 end as is_delivered
    from {{ ref('fct__shopify__fulfillment') }}
),

fulfillment_agg as (

    select
        -- id
        order_globalid,
        source_relation,
        order_id,
        -- shipping info
        min(city) as city,
        min(country) as country,
        min(tracking_company) as tracking_company,
        min(name) as name,
        min(service) as service,
        min(shipping_address_country) as shipping_address_country,
        max(is_delivered) as is_delivered,
        -- orders
        {% if fivetran_utils.enabled_vars(['shopify__order_shipping_line', 'shopify__order_shipping_tax_line']) %}
        avg(order_total_shipping) as order_total_shipping,
        {% endif %}
        avg(order_value) as order_value,
        avg(order_refund_value) as order_refund_value,
        avg(order_total_quantity) as order_total_quantity,
        --timestamp
        max(estimated_delivery_at) as estimated_delivery_at,
        max(confirmed_at) as confirmed_at,
        max(delivered_at) as delivered_at,
        max(out_for_delivery_at) as out_for_delivery_at

    from fulfillment
    {{ dbt_utils.group_by(n=3) }}
),

final as (
    select
        *,
        timestampdiff(day, confirmed_at, delivered_at) as lead_time
    from fulfillment_agg
)

select * from final
