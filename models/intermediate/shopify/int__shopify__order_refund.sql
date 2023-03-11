with refunds as (

    select *
    from {{ ref('base__shopify__refund') }}

),

order_line_refunds as (

    select *
    from {{ ref('base__shopify__order_line_refund') }}

),

refund_join as (

    select
        -- pk
        order_line_refunds.unique_id,
        order_line_refunds.order_line_refund_id,
        -- fk
        order_line_refunds.order_line_id,
        order_line_refunds.restock_type,
        order_line_refunds.quantity,
        order_line_refunds.subtotal,
        order_line_refunds.total_tax,
        refunds.refund_id,
        refunds.created_at,
        refunds.order_id,
        refunds.user_id,
        refunds.source_relation

    from order_line_refunds
    left join refunds
        on order_line_refunds.refund_id = refunds.refund_id -- many to one
            and order_line_refunds.source_relation = refunds.source_relation

)

select *
from refund_join
