--To disable this model, set the below variable within your dbt_project.yml file to False.
{{ config(enabled=var('shopify_refund', True)) }}

-- this model will be all NULL until you have made a refund in Shopify

with base as (

    select *
    from {{ source('shopify','refund') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('shopify','refund')),
                staging_columns=get_shopify_refund_columns()
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
        refund_id,
        note,
        order_id,
        restock,
        total_duties_set,
        user_id,
        {{ dbt_date.convert_timezone(column='cast(created_at as ' ~ dbt_utils.type_timestamp() ~ ')', target_tz=var('shopify_timezone', "UTC"), source_tz="UTC") }} as created_at,
        {{ dbt_date.convert_timezone(column='cast(processed_at as ' ~ dbt_utils.type_timestamp() ~ ')', target_tz=var('shopify_timezone', "UTC"), source_tz="UTC") }} as processed_at,
        {{ dbt_date.convert_timezone(column='cast(_fivetran_synced as ' ~ dbt_utils.type_timestamp() ~ ')', target_tz=var('shopify_timezone', "UTC"), source_tz="UTC") }} as _fivetran_synced,
        source_relation

    from fields
)

select *
from final
