{{ config(enabled=var('salesforce__opportunity_enabled', True)) }}

with opportunity as (
    select * from {{ ref('stg__salesforce__opportunity') }}
),

account as (
    select *
    from {{ ref('base__salesforce__account') }}
),

joined as (
    select
        opportunity.*,
        account.account_source,
        account.industry,
        account.account_name,
        account.number_of_employees,
        account.account_type,
        account.account_host
    from opportunity
    left join account
        on opportunity.account_id = account.account_id --many-to-one
)

select * from joined
