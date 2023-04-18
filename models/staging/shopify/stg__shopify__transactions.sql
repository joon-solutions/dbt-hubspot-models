{{ config(enabled=var('shopify__transaction', True)) }}
{{ config(enabled=var('shopify__tender_transactions', True)) }}

with transactions as (
    select *
    from {{ ref('base__shopify__transaction') }}

),

tender_transactions as (

    select *
    from {{ ref('base__shopify__tender_transaction') }}

),

joined as (
    select
        transactions.*,
        tender_transactions.payment_method,
        parent_transactions.created_timestamp as parent_created_timestamp,
        parent_transactions.kind as parent_kind,
        parent_transactions.amount as parent_amount,
        parent_transactions.status as parent_status
    from transactions
    left join tender_transactions --one-to-one
        on transactions.transaction_globalid = tender_transactions.transaction_globalid
    -- and transactions.source_relation = tender_transactions.source_relation
    left join transactions as parent_transactions --many-to-one
        on transactions.parent_globalid = parent_transactions.transaction_globalid
            -- and transactions.source_relation = parent_transactions.source_relation

)

select *
from joined
