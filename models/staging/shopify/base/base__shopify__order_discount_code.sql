{{ config(enabled=var('shopify_enabled', True)) }}

with base as (

    select *
    from {{ ref('base__shopify__order_discount_code_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('base__shopify__order_discount_code_tmp')),
                staging_columns=get_shopify_order_discount_code_columns()
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
        order_id,
        upper(code) as code,
        type,
        amount,
        {{ dbt_date.convert_timezone(column='cast(_fivetran_synced as ' ~ dbt_utils.type_timestamp() ~ ')', target_tz=var('shopify_timezone', "UTC"), source_tz="UTC") }} as _fivetran_synced,
        source_relation

    from fields
    where index = 1 -- Sanity check. index should not > 1 but open an issue if that's not the case in your data
)

select
    *,
    {{ dbt_utils.surrogate_key(['order_id','code','source_relation']) }} as order_discount_code_globalid,
    {{ dbt_utils.surrogate_key(['order_id','source_relation']) }} as order_globalid
from final
