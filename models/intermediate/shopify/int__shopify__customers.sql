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
        customer_id,
        source_relation,
        {{ fivetran_utils.string_agg("distinct cast(value as " ~ dbt_utils.type_string() ~ ")", "', '") }} as customer_tags

    from customer_tags
    group by 1, 2
),

final as (

    select
        customer.*,
        customer_tags_aggregated.customer_tags
    from customer
    left join customer_tags_aggregated
        on customer.customer_id = customer_tags_aggregated.customer_id
            and customer.source_relation = customer_tags_aggregated.source_relation

)

select *
from final
