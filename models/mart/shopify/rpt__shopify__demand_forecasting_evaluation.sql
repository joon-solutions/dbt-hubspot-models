with demand_forecasting as (

    select *
    from {{ ref('fct__shopify__demand_forecasting') }}

),

final as (

    select
        order_month,
        sku,
        regr_r2(quantity, forecast_key) as r_square
    from demand_forecasting
    group by 1, 2

)

select *
from final
order by 2, 1
