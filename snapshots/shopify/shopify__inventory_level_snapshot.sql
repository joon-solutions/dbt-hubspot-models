{% snapshot shopify__inventory_level_snapshot %}

    {{
        config(
          unique_key=dbt_utils.surrogate_key(['inventory_item_id','location_id','_dbt_source_relation']),
          strategy='timestamp',
          updated_at='updated_at',
        )
    }}

{{
fivetran_utils.union_data(
    table_identifier='inventory_level', 
    default_database='joon_solutions',
    default_schema='shopify',
    default_variable='inventory_level_source',
    union_schema_variable='shopify_union_schemas',
    union_database_variable='shopify_union_databases'
) }}

{% endsnapshot %}