{{ config(enabled=var('shopify__inventory_level', True)) }}

with base as (

    select * from {{ ref('shopify__inventory_level_snapshot') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('shopify__inventory_level_snapshot')),
                staging_columns=get_shopify_inventory_level_columns()
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
        sku,
        inventory_item_id,
        location_id,
        {{ dbt_date.convert_timezone(column='cast(_fivetran_synced as ' ~ dbt_utils.type_timestamp() ~ ')', target_tz=var('shopify_timezone', "UTC"), source_tz="UTC") }} as _fivetran_synced,
        available,
        updated_at,
        source_relation,
        {{ dbt_utils.surrogate_key(['sku','source_relation']) }} as sku_globalid,
        {{ dbt_utils.surrogate_key(['inventory_item_id','updated_at','location_id','source_relation']) }} as id
    from fields

)

select *
from final
