{{ config(enabled=var('salesforce__opportunity_enabled', True)) }}

with opportunity as (

    select *
    from {{ ref('int__salesforce__opportunity_account') }}
),

joined as (

    select * from opportunity
)

select * from joined
