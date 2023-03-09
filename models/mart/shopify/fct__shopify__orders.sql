with orders as (

    select *
    from {{ ref('base__shopify__orders') }}

), order_lines as (

    select *
    from {{ ref('base__shopify__order_line') }}
), order_adjustments as (

    select *
    from {{ ref('base__shopify__order_adjustment') }}

), order_adjustments_aggregates as (
    select
        order_id,
        source_relation,
        sum(amount) as order_adjustment_amount,
        sum(tax_amount) as order_adjustment_tax_amount
    from order_adjustments
    group by 1,2

), refunds as (

    select *
    from {{ ref('int__shopify__order_refund') }}

), refund_aggregates as (
    select
        order_id,
        source_relation,
        sum(subtotal) as refund_subtotal,
        sum(total_tax) as refund_total_tax
    from refunds
    group by 1,2

), joined as (

    select
        orders.*,
        coalesce(cast({{ fivetran_utils.json_parse("total_shipping_price_set",["shop_money","amount"]) }} as {{ dbt.type_float() }}) ,0) as shipping_cost,
        
        order_adjustments_aggregates.order_adjustment_amount,
        order_adjustments_aggregates.order_adjustment_tax_amount,

        refund_aggregates.refund_subtotal,
        refund_aggregates.refund_total_tax,

        (orders.total_price
            + coalesce(order_adjustments_aggregates.order_adjustment_amount,0) + coalesce(order_adjustments_aggregates.order_adjustment_tax_amount,0) 
            - coalesce(refund_aggregates.refund_subtotal,0) - coalesce(refund_aggregates.refund_total_tax,0)) as order_adjusted_total,
        order_lines.line_item_count,

        coalesce(discount_aggregates.shipping_discount_amount, 0) as shipping_discount_amount,
        coalesce(discount_aggregates.percentage_calc_discount_amount, 0) as percentage_calc_discount_amount,
        coalesce(discount_aggregates.fixed_amount_discount_amount, 0) as fixed_amount_discount_amount,
        coalesce(discount_aggregates.count_discount_codes_applied, 0) as count_discount_codes_applied,
        coalesce(order_lines.order_total_shipping_tax, 0) as order_total_shipping_tax,
        -- order_tag.order_tags,
        -- order_url_tag.order_url_tags,
        -- fulfillments.number_of_fulfillments,
        -- fulfillments.fulfillment_services,
        -- fulfillments.tracking_companies,
        -- fulfillments.tracking_numbers


    from orders
    left join order_lines
        on orders.order_id = order_lines.order_id
        and orders.source_relation = order_lines.source_relation
    left join refund_aggregates
        on orders.order_id = refund_aggregates.order_id
        and orders.source_relation = refund_aggregates.source_relation
    left join order_adjustments_aggregates
        on orders.order_id = order_adjustments_aggregates.order_id
        and orders.source_relation = order_adjustments_aggregates.source_relation
    -- left join discount_aggregates
    --     on orders.order_id = discount_aggregates.order_id 
    --     and orders.source_relation = discount_aggregates.source_relation
    -- left join order_tag
    --     on orders.order_id = order_tag.order_id
    --     and orders.source_relation = order_tag.source_relation
    -- left join order_url_tag
    --     on orders.order_id = order_url_tag.order_id
    --     and orders.source_relation = order_url_tag.source_relation
    -- left join fulfillments
    --     on orders.order_id = fulfillments.order_id
    --     and orders.source_relation = fulfillments.source_relation

), windows as (

    select 
        *,
        row_number() over (partition by customer_id, source_relation order by created_timestamp) as customer_order_seq_number
    from joined

), new_vs_repeat as (

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