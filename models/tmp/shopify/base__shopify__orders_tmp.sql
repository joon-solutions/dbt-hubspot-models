{{ config(enabled=var('shopify_enabled', True)) }}

{{
fivetran_utils.union_data(
    table_identifier='order',
    default_database=target.database,
    default_schema='shopify',
    union_schema_variable='shopify_union_schemas',
    union_database_variable='shopify_union_databases'
)
}}
