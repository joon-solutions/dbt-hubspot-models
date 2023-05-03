{{ config(enabled=var('shopify_enabled', True)) }}

with customer as (

    select *
    from {{ ref('base__shopify__customer') }}

),

customer_tags as (

    select *
    from {{ ref('base__shopify__customer_tag') }}

),

customer_tags_aggregated as (

    select
        customer_globalid,
        customer_id,
        source_relation,
        {{ fivetran_utils.string_agg("distinct cast(value as " ~ dbt_utils.type_string() ~ ")", "', '") }} as customer_tags

    from customer_tags
    group by 1, 2, 3
),

final as (

    select
        customer.*,
        customer_tags_aggregated.customer_tags
    from customer
    left join customer_tags_aggregated
        on customer.customer_globalid = customer_tags_aggregated.customer_globalid

)

select *
from final
