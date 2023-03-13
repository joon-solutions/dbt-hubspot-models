-- this model will be all NULL until you have made an order adjustment in Shopify

with base as (

    {{
    fivetran_utils.union_data(
        table_identifier='order_adjustment', 
        default_database='joon_solutions',
        default_schema='shopify',
        union_schema_variable='shopify_union_schemas',
        union_database_variable='shopify_union_databases'
    ) }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('shopify','order_adjustment')),
                staging_columns=get_order_adjustment_columns()
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
        order_adjustment_id,
        order_id,
        refund_id,
        amount,
        amount_set,
        tax_amount,
        tax_amount_set,
        kind,
        reason,
        {{ dbt_date.convert_timezone(column='cast(_fivetran_synced as ' ~ dbt_utils.type_timestamp() ~ ')', target_tz=var('shopify_timezone', "UTC"), source_tz="UTC") }} as _fivetran_synced,
        source_relation,
        {{ dbt_utils.surrogate_key(['order_adjustment_id','source_relation']) }} as unique_id

    from fields
)

select *
from final
