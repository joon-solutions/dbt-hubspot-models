{{ config(enabled=var('shopify_enabled', False)) }}

-- this model will be all NULL until you have made a refund in Shopify

with base as (
    select *
    from {{ ref('base__shopify__tax_line_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('base__shopify__tax_line_tmp')),
                staging_columns=get_shopify_tax_line_columns()
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
        index,
        order_line_id,
        price,
        price_set,
        rate,
        title,
        {{ dbt_date.convert_timezone(column='cast(_fivetran_synced as ' ~ dbt_utils.type_timestamp() ~ ')', target_tz=var('shopify_timezone', "UTC"), source_tz="UTC") }} as _fivetran_synced,
        source_relation,
        {{ dbt_utils.surrogate_key(['index', 'order_line_id','source_relation']) }} as tax_line_globalid,
        {{ dbt_utils.surrogate_key(['order_line_id','source_relation']) }} as order_line_globalid

    from fields
)

select *
from final
