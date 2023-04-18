with base as (

    select *
    from {{ ref('base__shopify__customer_tag_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('base__shopify__customer_tag_tmp')),
                staging_columns=get_shopify_customer_tag_columns()
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
        customer_id,
        index,
        value,
        {{ dbt_date.convert_timezone(column='cast(_fivetran_synced as ' ~ dbt_utils.type_timestamp() ~ ')', target_tz=var('shopify_timezone', "UTC"), source_tz="UTC") }} as _fivetran_synced,
        source_relation,
        {{ dbt_utils.surrogate_key(['index', 'customer_id','source_relation']) }} as customer_tag_globalid,
        {{ dbt_utils.surrogate_key(['customer_id','source_relation']) }} as customer_globalid

    from fields
)

select *
from final
