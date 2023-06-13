with order_lines as (

    select *
    from {{ ref('stg__shopify__order_lines') }}

),

final as (

    select *
    from order_lines

)

select *
from final