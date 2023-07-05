with orders as (

    select *
    from {{ ref('base__shopify__orders') }}

),

final as (

    select *
    from orders

)

select * from final
