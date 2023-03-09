--To disable this model, set the below variable within your dbt_project.yml file to False.
{{ config(enabled=var('shopify_order_line_refund', True)) }}

-- this model will be all NULL until you have made an order line refund in Shopify

with base as (

     {{
    fivetran_utils.union_data(
        table_identifier='order_line_refund', 
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
                source_columns=adapter.get_columns_in_relation(source('shopify','order_line_refund')),
                staging_columns=get_shopify_order_line_refund_columns()
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
        order_line_refund_id,
        location_id,
        order_line_id,
        subtotal,
        subtotal_set,
        total_tax,
        total_tax_set,
        quantity,
        refund_id,
        restock_type,
        {{ dbt_date.convert_timezone(column='cast(_fivetran_synced as ' ~ dbt_utils.type_timestamp() ~ ')', target_tz=var('shopify_timezone', "UTC"), source_tz="UTC") }} as _fivetran_synced,
        source_relation

    from fields
)

select *
from final
