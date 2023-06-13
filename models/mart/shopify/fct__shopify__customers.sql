{{ config(enabled=var('shopify_enabled', False)) }}

with customers as (

    select
        {{ dbt_utils.star(from=ref('int__shopify__customers'), except=["orders_count", "total_spent"]) }}
    from {{ ref('int__shopify__customers') }}
),

abandoned as (

    select
        customer_globalid,
        customer_id,
        source_relation,
        count(checkout_globalid) as lifetime_abandoned_checkouts
    from {{ ref('base__shopify__abandoned_checkout') }}
    where customer_globalid is not null
    group by 1, 2, 3

),

orders as (
    select *
    from {{ ref('int__shopify__orders') }}
),

orders_aggregates as (
    select
        --pk
        customer_globalid,
        customer_id,
        source_relation,

        {% if fivetran_utils.enabled_vars(['shopify__order_shipping_line', 'shopify__order_shipping_tax_line']) %}
        sum(order_total_shipping) as lifetime_total_shipping,
        avg(order_total_shipping) as avg_shipping_per_order,
        sum(order_total_shipping_with_discounts) as lifetime_total_shipping_with_discounts,
        avg(order_total_shipping_with_discounts) as avg_shipping_with_discounts_per_order,
        sum(order_total_shipping_tax) as lifetime_total_shipping_tax,
        avg(order_total_shipping_tax) as avg_shipping_tax_per_order,
        {% endif %}

        --order metrics
        min(created_timestamp) as first_order_timestamp,
        max(created_timestamp) as most_recent_order_timestamp,
        count(order_globalid) as lifetime_count_orders,
        --transaction metrics
        avg(order_value) as avg_order_value,
        sum(order_value) as lifetime_total_spent,
        --refund metrics
        sum(order_refund_value) as lifetime_total_refunded,
        --order line
        avg(order_total_quantity) as avg_quantity_per_order,
        sum(order_total_tax) as lifetime_total_tax,
        avg(order_total_tax) as avg_tax_per_order,
        sum(order_total_discount) as lifetime_total_discount,
        avg(order_total_discount) as avg_discount_per_order
    from orders
    group by 1, 2, 3
),

joined as (

    select
        customers.*,
        coalesce(abandoned.lifetime_abandoned_checkouts, 0) as lifetime_abandoned_checkouts,
        ---order metrics

        {% if fivetran_utils.enabled_vars(['shopify__order_shipping_line', 'shopify__order_shipping_tax_line']) %}
        coalesce(orders_aggregates.lifetime_total_shipping, 0) as lifetime_total_shipping,
        orders_aggregates.avg_shipping_per_order,
        coalesce(orders_aggregates.lifetime_total_shipping_with_discounts, 0) as lifetime_total_shipping_with_discounts,
        orders_aggregates.avg_shipping_with_discounts_per_order,
        coalesce(orders_aggregates.lifetime_total_shipping_tax, 0) as lifetime_total_shipping_tax,
        orders_aggregates.avg_shipping_tax_per_order,
        {% endif %}

        orders_aggregates.first_order_timestamp,
        orders_aggregates.most_recent_order_timestamp,
        datediff(day, orders_aggregates.most_recent_order_timestamp, convert_timezone('UTC', {{ var('shopify_timezone', "'UTC'") }}, sysdate() )) as days_since_last_orders,
        -- orders_aggregates.avg_order_value,
        coalesce(orders_aggregates.lifetime_total_spent, 0) as lifetime_total_spent,
        coalesce(orders_aggregates.lifetime_total_refunded, 0) as lifetime_total_refunded,
        (coalesce(orders_aggregates.lifetime_total_spent, 0) - coalesce(orders_aggregates.lifetime_total_refunded, 0)) as lifetime_total_net,
        coalesce(orders_aggregates.lifetime_count_orders, 0) as lifetime_count_orders,
        orders_aggregates.avg_quantity_per_order,
        coalesce(orders_aggregates.lifetime_total_tax, 0) as lifetime_total_tax,
        orders_aggregates.avg_tax_per_order,
        coalesce(orders_aggregates.lifetime_total_discount, 0) as lifetime_total_discount,
        orders_aggregates.avg_discount_per_order

    from customers
    left join abandoned --one-to-one
        on customers.customer_globalid = abandoned.customer_globalid
    -- and customers.source_relation = abandoned.source_relation
    left join orders_aggregates ---one-to-one
        on customers.customer_globalid = orders_aggregates.customer_globalid
-- and customers.source_relation = orders_aggregates.source_relation
)

select *
from joined
