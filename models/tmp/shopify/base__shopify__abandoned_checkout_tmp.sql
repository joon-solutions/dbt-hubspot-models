{{
    fivetran_utils.union_data(
        table_identifier='abandoned_checkout', 
        default_database='joon_solutions',
        default_schema='shopify',
        union_schema_variable='shopify_union_schemas',
        union_database_variable='shopify_union_databases'
    )
}}