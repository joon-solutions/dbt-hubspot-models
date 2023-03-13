with orders as (

    select *
    from {{ ref('base__shopify__orders') }}

),

order_lines_agg as (

    select *
    from {{ ref('stg__shopify__order_line_aggregates') }}

),

{% if fivetran_utils.enabled_vars(['shopify__order_shipping_line', 'shopify__order_shipping_tax_line']) %}

shipping as (
    select *
    from {{ ref('stg__shopify__order__shipping_aggregates') }}
),

{% endif %}

transactions as (
    select *
    from {{ ref('stg__shopify__transactions')}}
    where lower(status) = 'success'
    and lower(kind) not in ('authorization', 'void')
    and lower(gateway) != 'gift_card' -- redeeming a giftcard does not introduce new revenue

),

-- transaction_aggregates as (
--     -- this is necessary as customers can pay via multiple payment gateways
--     select 
--         order_id,
--         source_relation,
--         kind,
--         sum(currency_exchange_calculated_amount) as currency_exchange_calculated_amount

--     from transactions
--     {{ dbt_utils.group_by(n=3) }}
-- ),

final as (
    select 
        orders.*,
        --shipping metrics
        {% if fivetran_utils.enabled_vars(['shopify__order_shipping_line', 'shopify__order_shipping_tax_line']) %}
        shipping.shipping_price as order_total_shipping,
        shipping.discounted_shipping_price as order_total_shipping_with_discounts,
        shipping.shipping_tax as order_total_shipping_tax,
        {% endif %}
        ---order_line metrics
        order_lines_agg.line_item_count,
        order_lines_agg.order_total_quantity,
        order_lines_agg.order_total_tax,
        order_lines_agg.order_total_discount
        ---order value
        -- transaction_aggregates.currency_exchange_calculated_amount as order_value
        ---refund
        -- refunds.currency_exchange_calculated_amount as order_refund_value,

    from orders
    left join order_lines_agg 
        on orders.order_id = order_lines_agg.order_id
        and orders.source_relation = order_lines_agg.source_relation
    {% if fivetran_utils.enabled_vars(['shopify__order_shipping_line', 'shopify__order_shipping_tax_line']) %}
    left join shipping
        on orders.order_id = shipping.order_id
        and orders.source_relation = shipping.source_relation
    {% endif %}
    -- left join transaction_aggregates
    --     on orders.order_id = transaction_aggregates.order_id
    --     and orders.source_relation = transaction_aggregates.source_relation
    --     and transaction_aggregates.kind in ('sale','capture')
    -- left join transaction_aggregates as refunds
    --     on orders.order_id = refunds.order_id
    --     and orders.source_relation = refunds.source_relation
    --     and refunds.kind = 'refund'
)

select * from final