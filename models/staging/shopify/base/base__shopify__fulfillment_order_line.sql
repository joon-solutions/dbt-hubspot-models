{{ config(enabled=var('shopify_enabled', True)) }}

with base as (

    select *
    from {{ ref('base__shopify__fulfillment_order_line_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('base__shopify__fulfillment_order_line_tmp')),
                staging_columns=get_shopify_fulfillment_order_line_columns()
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
        fulfillment_id,
        order_line_id,
        product_id,
        variant_id,
        fulfillable_quantity,
        fulfillment_service,
        gift_card,
        grams,
        price_set,
        price,
        properties,
        quantity,
        requires_shipping,
        sku,
        taxable,
        title,
        variant_title,
        vendor,
        {{ dbt_date.convert_timezone(column='cast(_fivetran_synced as ' ~ dbt_utils.type_timestamp() ~ ')', target_tz=var('shopify_timezone', "UTC"), source_tz="UTC") }} as _fivetran_synced,
        source_relation

    from fields
)

select
    *,
    {{ dbt_utils.surrogate_key(['fulfillment_id','source_relation']) }} as fulfillment_globalid,
    {{ dbt_utils.surrogate_key(['fulfillment_id','order_line_id','source_relation']) }} as fulfillment_order_line_globalid
from final
