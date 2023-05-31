{{ config(enabled=var('shopify__transaction', True)) }}
{{ config(enabled=var('shopify__tender_transactions', True)) }}

with transactions as (

    select
        *,
        case
            when extract(minute from created_timestamp) <= 10 then 10
            when extract(minute from created_timestamp) <= 20 then 20
            when extract(minute from created_timestamp) <= 30 then 30
            when extract(minute from created_timestamp) <= 40 then 40
            when extract(minute from created_timestamp) <= 50 then 50
            else 60 end as created_minute,
        extract(hour from created_timestamp) as created_hour,
        date(created_timestamp) as created_date,
        date_trunc(week, created_timestamp) as created_week
    from {{ ref('stg__shopify__transactions') }}

),

fraud_count as (

    select
        *,
        --how many times a credit card has been used within 10 mins
        count(distinct order_globalid) over (
            partition by payment_credit_card_number, created_minute, created_hour, created_date) as order_by_credit_card,
        --how many different credit cards a certain user id has attempted within 10 mins
        count(distinct payment_credit_card_number) over (
            partition by user_id, created_minute, created_hour, created_date) as credit_card_by_user,
        --how many void transactions a certain user id has within 7 days
        count(distinct case when kind = 'void' then transaction_globalid end) over (
            partition by user_id, created_week) as void_transaction_by_user
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
