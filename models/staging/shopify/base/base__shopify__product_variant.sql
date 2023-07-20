with base as (

    select *
    from {{ ref('base__shopify__product_variant_tmp') }}

),

fields as (

    select

        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('base__shopify__product_variant_tmp')),
                staging_columns=get_shopify_product_variant_columns()
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
        product_variant_id,
        product_id,
        inventory_item_id,
        image_id,
        title,
        price,
        sku,
        position,
        inventory_policy,
        compare_at_price,
        fulfillment_service,
        inventory_management,
        is_taxable,
        barcode,
        grams,
        coalesce(inventory_quantity, old_inventory_quantity) as inventory_quantity,
        weight,
        weight_unit,
        option_1,
        option_2,
        option_3,
        tax_code,
        {{ dbt_date.convert_timezone(column='cast(created_at as ' ~ dbt_utils.type_timestamp() ~ ')', target_tz=var('shopify_timezone', "UTC"), source_tz="UTC") }} as created_timestamp,
        {{ dbt_date.convert_timezone(column='cast(updated_at as ' ~ dbt_utils.type_timestamp() ~ ')', target_tz=var('shopify_timezone', "UTC"), source_tz="UTC") }} as updated_timestamp,
        {{ dbt_date.convert_timezone(column='cast(_fivetran_synced as ' ~ dbt_utils.type_timestamp() ~ ')', target_tz=var('shopify_timezone', "UTC"), source_tz="UTC") }} as _fivetran_synced,
        source_relation

    from fields
)

select
    *,
    {{ dbt_utils.surrogate_key(['product_id','source_relation']) }} as product_globalid,
    {{ dbt_utils.surrogate_key(['product_variant_id','source_relation']) }} as product_variant_globalid,
    {{ dbt_utils.surrogate_key(['sku','source_relation']) }} as sku_globalid
from final
