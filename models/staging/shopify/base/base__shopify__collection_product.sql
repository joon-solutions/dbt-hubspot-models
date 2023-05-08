with base as (

    select *
    from {{ ref('base__shopify__collection_product_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('base__shopify__collection_product_tmp')),
                staging_columns=get_shopify_collection_product_columns()
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
        collection_id,
        product_id,
        {{ dbt_date.convert_timezone(column='cast(_fivetran_synced as ' ~ dbt_utils.type_timestamp() ~ ')', target_tz=var('shopify_timezone', "UTC"), source_tz="UTC") }} as _fivetran_synced,
        source_relation

    from fields
)

select
    *,
    {{ dbt_utils.surrogate_key(['collection_id','source_relation']) }} as collection_globalid,
    {{ dbt_utils.surrogate_key(['product_id','source_relation']) }} as product_globalid,
    {{ dbt_utils.surrogate_key(['collection_id', 'product_id','source_relation']) }} as unique_key
from final
