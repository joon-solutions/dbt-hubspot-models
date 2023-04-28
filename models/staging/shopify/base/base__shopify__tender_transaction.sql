
{{ config(enabled=var('shopify__tender_transactions', True)) }}

with base as (

    select *
    from {{ ref('base__shopify__tender_transaction_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('base__shopify__tender_transaction_tmp')),
                staging_columns=get_shopify_tender_transaction_columns()
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
        transaction_id,
        order_id,
        amount,
        currency,
        payment_method,
        remote_reference as transaction_remote_reference,
        user_id,
        {{ dbt_date.convert_timezone(column='cast(processed_at as ' ~ dbt_utils.type_timestamp() ~ ')', target_tz=var('shopify_timezone', "UTC"), source_tz="UTC") }} as processed_at,
        {{ dbt_date.convert_timezone(column='cast(_fivetran_synced as ' ~ dbt_utils.type_timestamp() ~ ')', target_tz=var('shopify_timezone', "UTC"), source_tz="UTC") }} as _fivetran_synced,
        source_relation,
        {{ dbt_utils.surrogate_key(['transaction_id','order_id','source_relation']) }} as tender_transaction_globalid,
        {{ dbt_utils.surrogate_key(['transaction_id','source_relation']) }} as transaction_globalid,
        {{ dbt_utils.surrogate_key(['order_id','source_relation']) }} as order_globalid


    from fields
    where not coalesce(test, false)
)

select *
from final
