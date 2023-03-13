{{ config(enabled=var('shopify__order_shipping_line', True)) }}

{{
fivetran_utils.union_data(
    table_identifier='order_shipping_line', 
    default_database='joon_solutions',
    default_schema='shopify',
    union_schema_variable='shopify_union_schemas',
    union_database_variable='shopify_union_databases'
) }}
