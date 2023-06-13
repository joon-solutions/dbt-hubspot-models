with demand_forecasting as (

    select *
    from {{ ref('rpt__shopify__demand_forecasting') }}

),

final as (

    select
        sku,
        regr_r2(quantity, forecast_key) as r_square
    from demand_forecasting
    group by 1

)

select *
from final