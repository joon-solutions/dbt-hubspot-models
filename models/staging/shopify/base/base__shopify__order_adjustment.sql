-- this model will be all NULL until you have made an order adjustment in Shopify

with base as (

    select *
    from {{ source('shopify','order_adjustment') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('shopify','order_adjustment')),
                staging_columns=get_order_adjustment_columns()
            )
        }}

        {{ fivetran_utils.source_relation(
            union_schema_variable='shopify_union_schemas', 
            union_database_variable='shopify_union_databases') 
        }}

    from base
),

final as (

    select
        order_adjustment_id,
        order_id,
        refund_id,
        amount,
        amount_set,
        tax_amount,
        tax_amount_set,
        kind,
        reason,
        {{ dbt_date.convert_timezone(column='cast(_fivetran_synced as ' ~ dbt_utils.type_timestamp() ~ ')', target_tz=var('shopify_timezone', "UTC"), source_tz="UTC") }} as _fivetran_synced,
        source_relation

    from fields
)

select *
from final
