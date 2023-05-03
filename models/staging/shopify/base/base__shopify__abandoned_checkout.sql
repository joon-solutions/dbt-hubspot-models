{{ config(enabled=var('shopify_enabled', True)) }}

with base as (

    select *
    from {{ ref('base__shopify__abandoned_checkout_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('base__shopify__abandoned_checkout_tmp')),
                staging_columns=get_shopify_abandoned_checkout_columns()
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
        checkout_id,
        customer_id,
        user_id,
        is_deleted,
        has_buyer_accepted_marketing,
        abandoned_checkout_url,
        has_taxes_included,
        billing_address_address_1,
        billing_address_address_2,
        billing_address_city,
        billing_address_company,
        billing_address_country,
        billing_address_country_code,
        billing_address_first_name,
        billing_address_last_name,
        billing_address_latitude,
        billing_address_longitude,
        billing_address_name,
        billing_address_phone,
        billing_address_province,
        billing_address_province_code,
        billing_address_zip,
        cart_token,
        {{ dbt_date.convert_timezone(column='cast(created_at as ' ~ dbt_utils.type_timestamp() ~ ')', target_tz=var('shopify_timezone', "UTC"), source_tz="UTC") }} as created_at,
        {{ dbt_date.convert_timezone(column='cast(closed_at as ' ~ dbt_utils.type_timestamp() ~ ')', target_tz=var('shopify_timezone', "UTC"), source_tz="UTC") }} as closed_at,
        shop_currency,
        customer_locale,
        device_id,
        email,
        gateway,
        landing_site_base_url,
        location_id,
        name,
        note,
        phone,
        presentment_currency,
        referring_site,
        shipping_address_address_1,
        shipping_address_address_2,
        shipping_address_city,
        shipping_address_company,
        shipping_address_country,
        shipping_address_country_code,
        shipping_address_first_name,
        shipping_address_last_name,
        shipping_address_latitude,
        shipping_address_longitude,
        shipping_address_name,
        shipping_address_phone,
        shipping_address_province,
        shipping_address_province_code,
        shipping_address_zip,
        source_name,
        subtotal_price,
        token,
        total_discounts,
        total_duties,
        total_line_items_price,
        total_price,
        total_tax,
        total_weight,
        {{ dbt_date.convert_timezone(column='cast(updated_at as ' ~ dbt_utils.type_timestamp() ~ ')', target_tz=var('shopify_timezone', "UTC"), source_tz="UTC") }} as updated_at,
        {{ dbt_date.convert_timezone(column='cast(_fivetran_synced as ' ~ dbt_utils.type_timestamp() ~ ')', target_tz=var('shopify_timezone', "UTC"), source_tz="UTC") }} as _fivetran_synced,
        source_relation

    from fields
)

select
    *,
    {{ dbt_utils.surrogate_key(['checkout_id', 'source_relation']) }} as checkout_globalid,
    {{ dbt_utils.surrogate_key(['customer_id', 'source_relation']) }} as customer_globalid
from final
