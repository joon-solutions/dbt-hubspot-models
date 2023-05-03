{{ config(enabled=var('shopify_enabled', True)) }}

with base as (

    select *
    from {{ ref('base__shopify__fulfillment_event_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('base__shopify__fulfillment_event_tmp')),
                staging_columns=get_shopify_fulfillment_event_columns()
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
        id as fulfillment_event_id,
        address_1,
        city,
        country,
        fulfillment_id,
        latitude,
        longitude,
        message as fulfilment_message,
        order_id,
        province,
        shop_id,
        status as event_status,
        zip,
        {{ dbt_date.convert_timezone(column='cast(estimated_delivery_at as ' ~ dbt_utils.type_timestamp() ~ ')', target_tz=var('shopify_timezone', "UTC"), source_tz="UTC") }} as estimated_delivery_at,
        {{ dbt_date.convert_timezone(column='cast(happened_at as ' ~ dbt_utils.type_timestamp() ~ ')', target_tz=var('shopify_timezone', "UTC"), source_tz="UTC") }} as event_happened_at,
        {{ dbt_date.convert_timezone(column='cast(created_at as ' ~ dbt_utils.type_timestamp() ~ ')', target_tz=var('shopify_timezone', "UTC"), source_tz="UTC") }} as event_created_at,
        {{ dbt_date.convert_timezone(column='cast(updated_at as ' ~ dbt_utils.type_timestamp() ~ ')', target_tz=var('shopify_timezone', "UTC"), source_tz="UTC") }} as event_updated_at,
        {{ dbt_date.convert_timezone(column='cast(_fivetran_synced as ' ~ dbt_utils.type_timestamp() ~ ')', target_tz=var('shopify_timezone', "UTC"), source_tz="UTC") }} as _fivetran_synced,
        source_relation

    from fields
)

select
    *,
    {{ dbt_utils.surrogate_key(['fulfillment_event_id','source_relation']) }} as fulfillment_event_globalid,
    {{ dbt_utils.surrogate_key(['fulfillment_id','source_relation']) }} as fulfillment_globalid,
    {{ dbt_utils.surrogate_key(['order_id','source_relation']) }} as order_globalid
from final
