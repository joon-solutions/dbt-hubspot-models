{{ config(enabled=var('shopify__transaction', True)) }}
{{ config(enabled=var('shopify__tender_transactions', True)) }}

with transactions as (

    select
        *,
        time_slice(created_timestamp, 1, 'minute') as created_minute,
        -- extract(hour from created_timestamp) as created_hour,
        date(created_timestamp) as created_date
    from {{ ref('stg__shopify__transactions') }}

),

fraud_count as (

    select
        *,
        --how many times a credit card has been used within 10 mins
        count(transaction_globalid) over (
            partition by payment_credit_card_number order by created_minute rows between 10 preceding and current row) as order_by_credit_card,
        --how many different credit cards a certain user id has attempted within 10 mins
        count(payment_credit_card_number) over (
            partition by user_id order by created_minute rows between 10 preceding and current row) as credit_card_by_user,
        --how many void transactions a certain user id has within 7 days
        count(case when kind = 'void' then transaction_globalid end) over (
            partition by user_id order by created_date rows between 7 preceding and current row) as void_transaction_by_user
    from transactions

),

final as (

    select
        *,
        --fraud score
        case
            when order_by_credit_card >= 5 then 1
            else 0 end as fraud_credit_card_score,
        case
            when credit_card_by_user >= 2 then 1
            else 0 end as fraud_user_score,
        case
            when void_transaction_by_user >= 5 then 1
            else 0 end as fraud_void_transation_score,
        case
            when order_by_credit_card >= 5 then 1
            else 0 end +
        case
            when credit_card_by_user >= 2 then 1
            else 0 end +
        case
            when void_transaction_by_user >= 5 then 1
            else 0 end as fraud_score

    from fraud_count

)

select *
from final
