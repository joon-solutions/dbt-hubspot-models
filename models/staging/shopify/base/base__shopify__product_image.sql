{{ config(enabled=var('shopify_enabled', True)) }}
with base as (

    select *
    from {{ ref('base__shopify__product_image_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('base__shopify__product_image_tmp')),
                staging_columns=get_shopify_product_image_columns()
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
        product_image_id,
        product_id,
        height,
        position,
        src,
        variant_ids,
        width,
        {{ dbt_date.convert_timezone(column='cast(created_at as ' ~ dbt_utils.type_timestamp() ~ ')', target_tz=var('shopify_timezone', "UTC"), source_tz="UTC") }} as created_at,
        {{ dbt_date.convert_timezone(column='cast(updated_at as ' ~ dbt_utils.type_timestamp() ~ ')', target_tz=var('shopify_timezone', "UTC"), source_tz="UTC") }} as updated_at,
        {{ dbt_date.convert_timezone(column='cast(_fivetran_synced as ' ~ dbt_utils.type_timestamp() ~ ')', target_tz=var('shopify_timezone', "UTC"), source_tz="UTC") }} as _fivetran_synced,
        source_relation

    from fields
    where not coalesce(_fivetran_deleted, false)
)

select
    *,
    {{ dbt_utils.surrogate_key(['product_id','source_relation']) }} as product_globalid,
    {{ dbt_utils.surrogate_key(['product_image_id','source_relation']) }} as product_image_globalid
from final
