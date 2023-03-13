--To disable this model, set the below variable within your dbt_project.yml file to False.
{{ config(enabled=var('shopify_order_line', True)) }}

with base as (

    {{
    fivetran_utils.union_data(
        table_identifier='order_line', 
        default_database='joon_solutions',
        default_schema='shopify',
        union_schema_variable='shopify_union_schemas',
        union_database_variable='shopify_union_databases'
    ) }}

),

fields as (

    select

        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('shopify','order_line')),
                staging_columns=get_shopify_order_line_columns()
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
        order_line_id,
        order_index,
        order_name,
        order_id,
        fulfillable_quantity,
        fulfillment_service,
        fulfillment_status,
        is_gift_card,
        grams,
        pre_tax_price,
        pre_tax_price_set,
        price,
        price_set,
        product_id,
        quantity,
        is_shipping_required,
        sku,
        is_taxable,
        tax_code,
        title,
        total_discount,
        total_discount_set,
        variant_id,
        variant_title,
        variant_inventory_management,
        vendor,
        properties,
        destination_location_address_1,
        destination_location_address_2,
        destination_location_city,
        destination_location_country_code,
        destination_location_id,
        destination_location_name,
        destination_location_province_code,
        destination_location_zip,
        origin_location_address_1,
        origin_location_address_2,
        origin_location_city,
        origin_location_country_code,
        origin_location_id,
        origin_location_name,
        origin_location_province_code,
        origin_location_zip,
        {{ dbt_date.convert_timezone(column='cast(_fivetran_synced as ' ~ dbt_utils.type_timestamp() ~ ')', target_tz=var('shopify_timezone', "UTC"), source_tz="UTC") }} as _fivetran_synced,
        source_relation,
        {{ dbt_utils.surrogate_key(['order_line_id','source_relation']) }} as unique_id

    from fields

)

select *
from final
