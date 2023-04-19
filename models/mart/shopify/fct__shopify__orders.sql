with orders as (

    select *
    from {{ ref('int__shopify__orders') }}

),

order_adjustments as (

    select *
    from {{ ref('base__shopify__order_adjustment') }}

),

order_adjustments_aggregates as (
    select
        order_globalid,
        source_relation,
        sum(amount) as order_adjustment_amount,
        sum(tax_amount) as order_adjustment_tax_amount
    from order_adjustments
    group by 1, 2

),

refunds as (

    select *
    from {{ ref('int__shopify__order_refund') }}

),

refund_aggregates as (
    select
        order_globalid,
        source_relation,
        sum(subtotal) as refund_subtotal,
        sum(total_tax) as refund_total_tax
    from refunds
    group by 1, 2

),

fulfillments as (

    select
        order_globalid,
        source_relation,
        count(distinct fulfillment_globalid) as count_fulfillments,
        count(fulfillment_event_globalid) as count_fulfillment_events,
        {{ fivetran_utils.string_agg("distinct cast(service as " ~ dbt_utils.type_string() ~ ")", "', '") }} as fulfillment_services,
        {{ fivetran_utils.string_agg("distinct cast(tracking_company as " ~ dbt_utils.type_string() ~ ")", "', '") }} as tracking_companies,
        {{ fivetran_utils.string_agg("distinct cast(tracking_number as " ~ dbt_utils.type_string() ~ ")", "', '") }} as tracking_numbers

    from {{ ref('int__shopify__fulfillment') }}
    group by 1, 2
),

order_discount_code as (

    select *
    from {{ ref('base__shopify__order_discount_code') }}

),

discount_aggregates as (

    select
        order_globalid,
        source_relation,
        sum(case when type = 'shipping' then amount else 0 end) as shipping_discount_amount,
        sum(case when type = 'percentage' then amount else 0 end) as percentage_calc_discount_amount,
        sum(case when type = 'fixed_amount' then amount else 0 end) as fixed_amount_discount_amount,
        count(distinct code) as unique_codes_applied_count

    from order_discount_code
    group by 1, 2
),

joined as (

    select
        orders.*,
        coalesce(cast({{ fivetran_utils.json_parse("total_shipping_price_set",["shop_money","amount"]) }} as {{ dbt_utils.type_float() }}), 0) as shipping_cost,

        coalesce(order_adjustments_aggregates.order_adjustment_amount, 0) as order_adjustment_amount,
        coalesce(order_adjustments_aggregates.order_adjustment_tax_amount, 0) as order_adjustment_tax_amount,

        coalesce(refund_aggregates.refund_subtotal, 0) as refund_subtotal,
        coalesce(refund_aggregates.refund_total_tax, 0) as refund_total_tax,

        (orders.total_price
            + coalesce(order_adjustments_aggregates.order_adjustment_amount, 0) + coalesce(order_adjustments_aggregates.order_adjustment_tax_amount, 0)
            - coalesce(refund_aggregates.refund_subtotal, 0) - coalesce(refund_aggregates.refund_total_tax, 0)) as order_adjusted_total,

        coalesce(discount_aggregates.shipping_discount_amount, 0) as shipping_discount_amount,
        coalesce(discount_aggregates.percentage_calc_discount_amount, 0) as percentage_calc_discount_amount,
        coalesce(discount_aggregates.fixed_amount_discount_amount, 0) as fixed_amount_discount_amount,
        coalesce(discount_aggregates.unique_codes_applied_count, 0) as unique_codes_applied_count,
        coalesce(fulfillments.count_fulfillments, 0) as count_fulfillments,
        fulfillments.fulfillment_services,
        fulfillments.tracking_companies,
        fulfillments.tracking_numbers


    from orders
    left join refund_aggregates
        on orders.order_globalid = refund_aggregates.order_globalid -- one to one relationship
    -- and orders.source_relation = refund_aggregates.source_relation
    left join order_adjustments_aggregates
        on orders.order_globalid = order_adjustments_aggregates.order_globalid -- one to one relationship
    -- and orders.source_relation = order_adjustments_aggregates.source_relation
    left join discount_aggregates -- one to one relationship
        on orders.order_globalid = discount_aggregates.order_globalid
    -- and orders.source_relation = discount_aggregates.source_relation
    left join fulfillments -- one to one relationship
        on orders.order_globalid = fulfillments.order_globalid
            -- and orders.source_relation = fulfillments.source_relation

),

windows as (

    select
        *,
        row_number() over (partition by customer_id, source_relation order by created_timestamp) as customer_order_seq_number
    from joined

),

new_vs_repeat as (

    select
        *,
        case
            when customer_order_seq_number = 1 then 'new'
            else 'repeat'
        end as new_vs_repeat
    from windows

)

select *
from new_vs_repeat
