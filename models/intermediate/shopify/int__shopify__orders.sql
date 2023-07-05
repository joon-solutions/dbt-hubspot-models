with orders as (

    select *
    from {{ ref('stg__shopify__orders') }}

),

order_lines as (

    select *
    from {{ ref('stg__shopify__order_lines') }}

),

order_lines_agg as (

    select
        order_globalid,
        count(*) as line_item_count,
        sum(quantity) as order_total_quantity,
        -- sum(pre_tax_price) as ,
        sum(total_discount) as order_total_discount,
        -- avg(quantity) as avg_quantity_per_order_line,
        -- avg(total_discount) as product_avg_discount_per_order_line,
        sum(order_line_tax) as order_total_tax,
        max(order_route) as order_route
    from order_lines
    group by 1

),

{% if fivetran_utils.enabled_vars(['shopify__order_shipping_line', 'shopify__order_shipping_tax_line']) %}

shipping as (
    select *
    from {{ ref('stg__shopify__order__shipping_aggregates') }}
),

{% endif %}

transactions as (
    select *
    from {{ ref('stg__shopify__transactions') }}
    where lower(status) = 'success'
        and lower(kind) not in ('authorization', 'void')
        and lower(gateway) != 'gift_card' -- redeeming a giftcard does not introduce new revenue

),

transaction_aggregates as (
    -- this is necessary as customers can pay via multiple payment gateways
    select
        order_globalid,
        order_id,
        source_relation,
        kind,
        sum(currency_exchange_final_amount) as currency_exchange_final_amount

    from transactions
    {{ dbt_utils.group_by(n=4) }}
),

order_tag as (

    select
        order_globalid,
        order_id,
        source_relation,
        {{ fivetran_utils.string_agg("distinct cast(value as " ~ dbt_utils.type_string() ~ ")", "', '") }} as order_tags

    from {{ ref('base__shopify__order_tag') }}
    group by 1, 2, 3

),

order_url_tag as (

    select
        order_globalid,
        order_id,
        source_relation,
        {{ fivetran_utils.string_agg("distinct cast(value as " ~ dbt_utils.type_string() ~ ")", "', '") }} as order_url_tags

    from {{ ref('base__shopify__order_url_tag') }}
    group by 1, 2, 3
),

final as (
    select
        orders.*,
        --shipping metrics
        {% if fivetran_utils.enabled_vars(['shopify__order_shipping_line', 'shopify__order_shipping_tax_line']) %}
        coalesce(shipping.shipping_price, 0) as order_total_shipping,
        coalesce(shipping.discounted_shipping_price, 0) as order_total_shipping_with_discounts,
        coalesce(shipping.shipping_tax, 0) as order_total_shipping_tax,
        {% endif %}
        ---order_line metrics
        order_lines_agg.order_route,
        coalesce(order_lines_agg.line_item_count, 0) as line_item_count,
        coalesce(order_lines_agg.order_total_quantity, 0) as order_total_quantity,
        coalesce(order_lines_agg.order_total_tax, 0) as order_total_tax,
        coalesce(order_lines_agg.order_total_discount, 0) as order_total_discount,
        ---order value
        coalesce(transaction_aggregates.currency_exchange_final_amount, 0) as order_value,
        ---refund
        coalesce(refunds.currency_exchange_final_amount, 0) as order_refund_value,
        ---tags
        order_tag.order_tags as order_tags,
        order_url_tag.order_url_tags as order_url_tags

    from orders
    left join order_lines_agg
        on orders.order_globalid = order_lines_agg.order_globalid
    -- and orders.source_relation = order_lines_agg.source_relation
    {% if fivetran_utils.enabled_vars(['shopify__order_shipping_line', 'shopify__order_shipping_tax_line']) %}
    left join shipping
        on orders.order_globalid = shipping.order_globalid
        -- and orders.source_relation = shipping.source_relation
    {% endif %}
    left join transaction_aggregates
        on orders.order_globalid = transaction_aggregates.order_globalid
            -- and orders.source_relation = transaction_aggregates.source_relation
            and transaction_aggregates.kind in ('sale', 'capture')
    left join transaction_aggregates as refunds
        on orders.order_globalid = refunds.order_globalid
            -- and orders.source_relation = refunds.source_relation
            and refunds.kind = 'refund'
    left join order_tag
        on orders.order_globalid = order_tag.order_globalid
    -- and orders.source_relation = order_tag.source_relation
    left join order_url_tag
        on orders.order_globalid = order_url_tag.order_globalid
-- and orders.source_relation = order_url_tag.source_relation
)

select * from final
