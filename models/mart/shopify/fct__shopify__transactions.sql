{{ config(enabled=var('shopify__transaction', True)) }}
{{ config(enabled=var('shopify__tender_transactions', True)) }}

with transactions as (

    select
        *,
        extract(hour from created_timestamp) as created_hour,
        date(created_timestamp) as created_date
    from {{ ref('stg__shopify__transactions') }}

),

fraud_detection as (

    select
        *,
        --how many different credit cards a certain user id has attempted within an hour
        count(distinct order_globalid) over (
            partition by payment_credit_card_number, created_hour, created_date) as fraud_credit_card_count,
        --how many times a credit card has been used within a certain time period
        count(distinct payment_credit_card_number) over (
            partition by payment_credit_card_number, created_hour, created_date) as fraud_user_count
    from transactions

),

final as (

    select
        *,
        case
            when fraud_credit_card_count > 2 then 'Fraud credit card'
            when fraud_credit_card_count > 2 then 'Fraud user'
            else 'No fraud' end as fraud_detection

    from fraud_detection

)

select *
from final
