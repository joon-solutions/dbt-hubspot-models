{{ config(enabled=var('shopify_enabled', False)) }}

with demand_forecasting as (

    select *
    from {{ ref('fct__shopify__demand_forecasting') }}

),

final as (

    select
        order_month,
        regr_r2(quantity, forecast_key) as r_square
    from demand_forecasting
    group by 1

)

select *
from final
order by 1
