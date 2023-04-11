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
    from {{ ref('stg__shopify__transactions') }}
    where lower(status) = 'success'
        and lower(kind) not in ('authorization', 'void')
        and lower(gateway) != 'gift_card' -- redeeming a giftcard does not introduce new revenue

),

transaction_aggregates as (
    -- this is necessary as customers can pay via multiple payment gateways
    select
        order_id,
        source_relation,
        kind,
        sum(currency_exchange_final_amount) as currency_exchange_final_amount

    from transactions
    {{ dbt_utils.group_by(n=3) }}
),

order_tag as (

    select
        order_id,
        source_relation,
        {{ fivetran_utils.string_agg("distinct cast(value as " ~ dbt_utils.type_string() ~ ")", "', '") }} as order_tags

    from {{ ref('base__shopify__order_tag') }}
    group by 1, 2

),

order_url_tag as (

    select
        order_id,
        source_relation,
        {{ fivetran_utils.string_agg("distinct cast(value as " ~ dbt_utils.type_string() ~ ")", "', '") }} as order_url_tags

    from {{ ref('base__shopify__order_url_tag') }}
    group by 1, 2
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
        on orders.order_id = order_lines_agg.order_id
            and orders.source_relation = order_lines_agg.source_relation
    {% if fivetran_utils.enabled_vars(['shopify__order_shipping_line', 'shopify__order_shipping_tax_line']) %}
    left join shipping
        on orders.order_id = shipping.order_id
        and orders.source_relation = shipping.source_relation
    {% endif %}
    left join transaction_aggregates
        on orders.order_id = transaction_aggregates.order_id
            and orders.source_relation = transaction_aggregates.source_relation
            and transaction_aggregates.kind in ('sale', 'capture')
    left join transaction_aggregates as refunds
        on orders.order_id = refunds.order_id
            and orders.source_relation = refunds.source_relation
            and refunds.kind = 'refund'
    left join order_tag
        on orders.order_id = order_tag.order_id
            and orders.source_relation = order_tag.source_relation
    left join order_url_tag
        on orders.order_id = order_url_tag.order_id
            and orders.source_relation = order_url_tag.source_relation
)

select * from final
