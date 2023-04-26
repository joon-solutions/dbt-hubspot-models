{% macro get_shopify_order_columns() %}

{% set columns = [
    {"name": "id", "datatype": dbt_utils.type_numeric(), "alias": "order_id"},
    {"name": "processed_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "user_id", "datatype": dbt_utils.type_numeric()},
    {"name": "total_discounts", "datatype": dbt_utils.type_float()},
    {"name": "total_discounts_set", "datatype": dbt_utils.type_string()},
    {"name": "total_line_items_price", "datatype": dbt_utils.type_float()},
    {"name": "total_line_items_price_set", "datatype": dbt_utils.type_string()},
    {"name": "total_price", "datatype": dbt_utils.type_float()},
    {"name": "total_price_set", "datatype": dbt_utils.type_string()},
    {"name": "total_price_usd", "datatype": dbt_utils.type_float()},
    {"name": "total_tax_set", "datatype": dbt_utils.type_string()},
    {"name": "total_tax", "datatype": dbt_utils.type_float()},
    {"name": "source_name", "datatype": dbt_utils.type_string()},
    {"name": "subtotal_price", "datatype": dbt_utils.type_float()},
    {"name": "taxes_included", "datatype": "boolean", "alias": "has_taxes_included"},
    {"name": "total_weight", "datatype": dbt_utils.type_numeric()},
    {"name": "total_tip_received", "datatype": dbt_utils.type_float()},
    {"name": "landing_site_base_url", "datatype": dbt_utils.type_string()},
    {"name": "location_id", "datatype": dbt_utils.type_numeric()},
    {"name": "name", "datatype": dbt_utils.type_string(), "alias": "order_name"},
    {"name": "note", "datatype": dbt_utils.type_string()},
    {"name": "number", "datatype": dbt_utils.type_numeric(), "alias": "shop_order_number"},
    {"name": "order_number", "datatype": dbt_utils.type_numeric()},
    {"name": "cancel_reason", "datatype": dbt_utils.type_string()},
    {"name": "cancelled_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "cart_token", "datatype": dbt_utils.type_string()},
    {"name": "checkout_token", "datatype": dbt_utils.type_string()},
    {"name": "closed_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "currency", "datatype": dbt_utils.type_string()},
    {"name": "customer_id", "datatype": dbt_utils.type_numeric()},
    {"name": "email", "datatype": dbt_utils.type_string()},
    {"name": "financial_status", "datatype": dbt_utils.type_string()},
    {"name": "fulfillment_status", "datatype": dbt_utils.type_string()},
    {"name": "processing_method", "datatype": dbt_utils.type_string()},
    {"name": "referring_site", "datatype": dbt_utils.type_string()},
    {"name": "billing_address_address_1", "datatype": dbt_utils.type_string()},
    {"name": "billing_address_address_2", "datatype": dbt_utils.type_string()},
    {"name": "billing_address_city", "datatype": dbt_utils.type_string()},
    {"name": "billing_address_company", "datatype": dbt_utils.type_string()},
    {"name": "billing_address_country", "datatype": dbt_utils.type_string()},
    {"name": "billing_address_country_code", "datatype": dbt_utils.type_string()},
    {"name": "billing_address_first_name", "datatype": dbt_utils.type_string()},
    {"name": "billing_address_last_name", "datatype": dbt_utils.type_string()},
    {"name": "billing_address_latitude", "datatype": dbt_utils.type_string()},
    {"name": "billing_address_longitude", "datatype": dbt_utils.type_string()},
    {"name": "billing_address_name", "datatype": dbt_utils.type_string()},
    {"name": "billing_address_phone", "datatype": dbt_utils.type_string()},
    {"name": "billing_address_province", "datatype": dbt_utils.type_string()},
    {"name": "billing_address_province_code", "datatype": dbt_utils.type_string()},
    {"name": "billing_address_zip", "datatype": dbt_utils.type_string()},
    {"name": "browser_ip", "datatype": dbt_utils.type_string()},
    {"name": "buyer_accepts_marketing", "datatype": "boolean", "alias": "has_buyer_accepted_marketing"},
    {"name": "total_shipping_price_set", "datatype": dbt_utils.type_string()},
    {"name": "shipping_address_address_1", "datatype": dbt_utils.type_string()},
    {"name": "shipping_address_address_2", "datatype": dbt_utils.type_string()},
    {"name": "shipping_address_city", "datatype": dbt_utils.type_string()},
    {"name": "shipping_address_company", "datatype": dbt_utils.type_string()},
    {"name": "shipping_address_country", "datatype": dbt_utils.type_string()},
    {"name": "shipping_address_country_code", "datatype": dbt_utils.type_string()},
    {"name": "shipping_address_first_name", "datatype": dbt_utils.type_string()},
    {"name": "shipping_address_last_name", "datatype": dbt_utils.type_string()},
    {"name": "shipping_address_latitude", "datatype": dbt_utils.type_string()},
    {"name": "shipping_address_longitude", "datatype": dbt_utils.type_string()},
    {"name": "shipping_address_name", "datatype": dbt_utils.type_string()},
    {"name": "shipping_address_phone", "datatype": dbt_utils.type_string()},
    {"name": "shipping_address_province", "datatype": dbt_utils.type_string()},
    {"name": "shipping_address_province_code", "datatype": dbt_utils.type_string()},
    {"name": "shipping_address_zip", "datatype": dbt_utils.type_string()},
    {"name": "test", "datatype": "boolean", "alias": "is_test_order"},
    {"name": "token", "datatype": dbt_utils.type_string()},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "app_id", "datatype": dbt_utils.type_int()},
    {"name": "checkout_id", "datatype": dbt_utils.type_int()},
    {"name": "client_details_user_agent", "datatype": dbt_utils.type_string()},
    {"name": "customer_locale", "datatype": dbt_utils.type_string()},
    {"name": "order_status_url", "datatype": dbt_utils.type_string()},
    {"name": "presentment_currency", "datatype": dbt_utils.type_string()},
    {"name": "confirmed", "datatype": "boolean", "alias": "is_confirmed"}
] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_shopify_refund_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "id", "datatype": dbt_utils.type_numeric(), "alias": "refund_id"},
    {"name": "note", "datatype": dbt_utils.type_string()},
    {"name": "order_id", "datatype": dbt_utils.type_numeric()},
    {"name": "processed_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "restock", "datatype": "boolean"},
    {"name": "total_duties_set", "datatype": dbt_utils.type_string()},
    {"name": "user_id", "datatype": dbt_utils.type_numeric()}
] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_shopify_order_line_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "fulfillable_quantity", "datatype": dbt_utils.type_numeric()},
    {"name": "fulfillment_service", "datatype": dbt_utils.type_string()},
    {"name": "fulfillment_status", "datatype": dbt_utils.type_string()},
    {"name": "gift_card", "datatype": "boolean", "alias": "is_gift_card"},
    {"name": "grams", "datatype": dbt_utils.type_numeric()},
    {"name": "id", "datatype": dbt_utils.type_numeric(), "alias": "order_line_id"},
    {"name": "index", "datatype": dbt_utils.type_numeric(), "alias": "order_index"},
    {"name": "name", "datatype": dbt_utils.type_string(), "alias": "order_name"},
    {"name": "order_id", "datatype": dbt_utils.type_numeric()},
    {"name": "pre_tax_price", "datatype": dbt_utils.type_float()},
    {"name": "pre_tax_price_set", "datatype": dbt_utils.type_string()},
    {"name": "price", "datatype": dbt_utils.type_float()},
    {"name": "price_set", "datatype": dbt_utils.type_string()},
    {"name": "product_id", "datatype": dbt_utils.type_numeric()},
    {"name": "quantity", "datatype": dbt_utils.type_numeric()},
    {"name": "requires_shipping", "datatype": "boolean", "alias": "is_shipping_required"},
    {"name": "sku", "datatype": dbt_utils.type_string()},
    {"name": "taxable", "datatype": "boolean", "alias": "is_taxable"},
    {"name": "tax_code", "datatype": dbt_utils.type_string()},
    {"name": "title", "datatype": dbt_utils.type_string()},
    {"name": "total_discount", "datatype": dbt_utils.type_float()},
    {"name": "total_discount_set", "datatype": dbt_utils.type_string()},
    {"name": "variant_id", "datatype": dbt_utils.type_numeric()},
    {"name": "variant_title", "datatype": dbt_utils.type_string()},
    {"name": "variant_inventory_management", "datatype": dbt_utils.type_string()},
    {"name": "vendor", "datatype": dbt_utils.type_string()},
    {"name": "properties", "datatype": dbt_utils.type_string()},
    {"name": "destination_location_address_1", "datatype": dbt_utils.type_string()},
    {"name": "destination_location_address_2", "datatype": dbt_utils.type_string()},
    {"name": "destination_location_city", "datatype": dbt_utils.type_string()},
    {"name": "destination_location_country_code", "datatype": dbt_utils.type_string()},
    {"name": "destination_location_id", "datatype": dbt_utils.type_int()},
    {"name": "destination_location_name", "datatype": dbt_utils.type_string()},
    {"name": "destination_location_province_code", "datatype": dbt_utils.type_string()},
    {"name": "destination_location_zip", "datatype": dbt_utils.type_string()},
    {"name": "origin_location_address_1", "datatype": dbt_utils.type_string()},
    {"name": "origin_location_address_2", "datatype": dbt_utils.type_string()},
    {"name": "origin_location_city", "datatype": dbt_utils.type_string()},
    {"name": "origin_location_country_code", "datatype": dbt_utils.type_string()},
    {"name": "origin_location_id", "datatype": dbt_utils.type_int()},
    {"name": "origin_location_name", "datatype": dbt_utils.type_string()},
    {"name": "origin_location_province_code", "datatype": dbt_utils.type_string()},
    {"name": "origin_location_zip", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_shopify_order_line_refund_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "id", "datatype": dbt_utils.type_numeric(), "alias": "order_line_refund_id"},
    {"name": "location_id", "datatype": dbt_utils.type_numeric()},
    {"name": "order_line_id", "datatype": dbt_utils.type_numeric()},
    {"name": "subtotal", "datatype": dbt_utils.type_numeric()},
    {"name": "subtotal_set", "datatype": dbt_utils.type_string()},
    {"name": "total_tax", "datatype": dbt_utils.type_numeric()},
    {"name": "total_tax_set", "datatype": dbt_utils.type_string()},
    {"name": "quantity", "datatype": dbt_utils.type_float()},
    {"name": "refund_id", "datatype": dbt_utils.type_numeric()},
    {"name": "restock_type", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_order_adjustment_columns() %}

{% set columns = [
    {"name": "id", "datatype":  dbt_utils.type_numeric(), "alias": "order_adjustment_id"},
    {"name": "order_id", "datatype":  dbt_utils.type_numeric()},
    {"name": "refund_id", "datatype":  dbt_utils.type_numeric()},
    {"name": "amount", "datatype": dbt_utils.type_float()},
    {"name": "amount_set", "datatype": dbt_utils.type_string()},
    {"name": "tax_amount", "datatype": dbt_utils.type_float()},
    {"name": "tax_amount_set", "datatype": dbt_utils.type_string()},
    {"name": "kind", "datatype": dbt_utils.type_string()},
    {"name": "reason", "datatype": dbt_utils.type_string()},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_shopify_customer_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "accepts_marketing", "datatype": "boolean"},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "default_address_id", "datatype": dbt_utils.type_numeric()},
    {"name": "email", "datatype": dbt_utils.type_string()},
    {"name": "first_name", "datatype": dbt_utils.type_string()},
    {"name": "id", "datatype": dbt_utils.type_numeric(), "alias": "customer_id"},
    {"name": "last_name", "datatype": dbt_utils.type_string()},
    {"name": "orders_count", "datatype": dbt_utils.type_numeric()},
    {"name": "phone", "datatype": dbt_utils.type_string()},
    {"name": "state", "datatype": dbt_utils.type_string()},
    {"name": "tax_exempt", "datatype": "boolean", "alias": "is_tax_exempt"},
    {"name": "total_spent", "datatype": dbt_utils.type_float()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "verified_email", "datatype": "boolean", "alias": "is_verified_email"},
    {"name": "email_marketing_consent_consent_updated_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "email_marketing_consent_opt_in_level", "datatype": dbt_utils.type_string()},
    {"name": "email_marketing_consent_state", "datatype": dbt_utils.type_string()},
    {"name": "note", "datatype": dbt_utils.type_string()},
    {"name": "accepts_marketing_updated_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "marketing_opt_in_level", "datatype": dbt_utils.type_string()},
    {"name": "lifetime_duration", "datatype": dbt_utils.type_string()},
    {"name": "currency", "datatype": dbt_utils.type_string()}
] %}

{{ fivetran_utils.add_pass_through_columns(columns, var('customer_pass_through_columns')) }}

{{ return(columns) }}

{% endmacro %}


{% macro get_shopify_abandoned_checkout_discount_code_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "amount", "datatype": dbt_utils.type_float()},
    {"name": "checkout_id", "datatype": dbt_utils.type_int()},
    {"name": "code", "datatype": dbt_utils.type_string()},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "discount_id", "datatype": dbt_utils.type_int()},
    {"name": "index", "datatype": dbt_utils.type_int()},
    {"name": "type", "datatype": dbt_utils.type_string()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_shopify_abandoned_checkout_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean", "alias": "is_deleted"},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "abandoned_checkout_url", "datatype": dbt_utils.type_string()},
    {"name": "billing_address_address_1", "datatype": dbt_utils.type_string()},
    {"name": "billing_address_address_2", "datatype": dbt_utils.type_string()},
    {"name": "billing_address_city", "datatype": dbt_utils.type_string()},
    {"name": "billing_address_company", "datatype": dbt_utils.type_string()},
    {"name": "billing_address_country", "datatype": dbt_utils.type_string()},
    {"name": "billing_address_country_code", "datatype": dbt_utils.type_string()},
    {"name": "billing_address_first_name", "datatype": dbt_utils.type_string()},
    {"name": "billing_address_last_name", "datatype": dbt_utils.type_string()},
    {"name": "billing_address_latitude", "datatype": dbt_utils.type_string()},
    {"name": "billing_address_longitude", "datatype": dbt_utils.type_string()},
    {"name": "billing_address_name", "datatype": dbt_utils.type_string()},
    {"name": "billing_address_phone", "datatype": dbt_utils.type_string()},
    {"name": "billing_address_province", "datatype": dbt_utils.type_string()},
    {"name": "billing_address_province_code", "datatype": dbt_utils.type_string()},
    {"name": "billing_address_zip", "datatype": dbt_utils.type_string()},
    {"name": "buyer_accepts_marketing", "datatype": "boolean", "alias": "has_buyer_accepted_marketing"},
    {"name": "cart_token", "datatype": dbt_utils.type_string()},
    {"name": "closed_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "currency", "datatype": dbt_utils.type_string(), "alias": "shop_currency"},
    {"name": "customer_id", "datatype": dbt_utils.type_int()},
    {"name": "customer_locale", "datatype": dbt_utils.type_string()},
    {"name": "device_id", "datatype": dbt_utils.type_int()},
    {"name": "email", "datatype": dbt_utils.type_string()},
    {"name": "gateway", "datatype": dbt_utils.type_string()},
    {"name": "id", "datatype": dbt_utils.type_int(), "alias": "checkout_id"},
    {"name": "landing_site_base_url", "datatype": dbt_utils.type_string()},
    {"name": "location_id", "datatype": dbt_utils.type_int()},
    {"name": "name", "datatype": dbt_utils.type_string()},
    {"name": "note", "datatype": dbt_utils.type_string()},
    {"name": "phone", "datatype": dbt_utils.type_string()},
    {"name": "presentment_currency", "datatype": dbt_utils.type_string()},
    {"name": "referring_site", "datatype": dbt_utils.type_string()},
    {"name": "shipping_address_address_1", "datatype": dbt_utils.type_string()},
    {"name": "shipping_address_address_2", "datatype": dbt_utils.type_string()},
    {"name": "shipping_address_city", "datatype": dbt_utils.type_string()},
    {"name": "shipping_address_company", "datatype": dbt_utils.type_string()},
    {"name": "shipping_address_country", "datatype": dbt_utils.type_string()},
    {"name": "shipping_address_country_code", "datatype": dbt_utils.type_string()},
    {"name": "shipping_address_first_name", "datatype": dbt_utils.type_string()},
    {"name": "shipping_address_last_name", "datatype": dbt_utils.type_string()},
    {"name": "shipping_address_latitude", "datatype": dbt_utils.type_string()},
    {"name": "shipping_address_longitude", "datatype": dbt_utils.type_string()},
    {"name": "shipping_address_name", "datatype": dbt_utils.type_string()},
    {"name": "shipping_address_phone", "datatype": dbt_utils.type_string()},
    {"name": "shipping_address_province", "datatype": dbt_utils.type_string()},
    {"name": "shipping_address_province_code", "datatype": dbt_utils.type_string()},
    {"name": "shipping_address_zip", "datatype": dbt_utils.type_string()},
    {"name": "source_name", "datatype": dbt_utils.type_string()},
    {"name": "subtotal_price", "datatype": dbt_utils.type_float()},
    {"name": "taxes_included", "datatype": "boolean", "alias": "has_taxes_included"},
    {"name": "token", "datatype": dbt_utils.type_string()},
    {"name": "total_discounts", "datatype": dbt_utils.type_float()},
    {"name": "total_duties", "datatype": dbt_utils.type_string()},
    {"name": "total_line_items_price", "datatype": dbt_utils.type_float()},
    {"name": "total_price", "datatype": dbt_utils.type_float()},
    {"name": "total_tax", "datatype": dbt_utils.type_float()},
    {"name": "total_weight", "datatype": dbt_utils.type_int()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "user_id", "datatype": dbt_utils.type_int()}
] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_shopify_order_shipping_line_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "carrier_identifier", "datatype": dbt_utils.type_string()},
    {"name": "code", "datatype": dbt_utils.type_string()},
    {"name": "delivery_category", "datatype": dbt_utils.type_string()},
    {"name": "discounted_price", "datatype": dbt_utils.type_float()},
    {"name": "discounted_price_set", "datatype": dbt_utils.type_string()},
    {"name": "id", "datatype": dbt_utils.type_int(), "alias": "order_shipping_line_id"},
    {"name": "order_id", "datatype": dbt_utils.type_int()},
    {"name": "phone", "datatype": dbt_utils.type_string()},
    {"name": "price", "datatype": dbt_utils.type_float()},
    {"name": "price_set", "datatype": dbt_utils.type_string()},
    {"name": "requested_fulfillment_service_id", "datatype": dbt_utils.type_string()},
    {"name": "source", "datatype": dbt_utils.type_string()},
    {"name": "title", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_shopify_shopify_order_shipping_tax_line_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "index", "datatype": dbt_utils.type_int()},
    {"name": "order_shipping_line_id", "datatype": dbt_utils.type_int()},
    {"name": "price", "datatype": dbt_utils.type_float()},
    {"name": "price_set", "datatype": dbt_utils.type_string()},
    {"name": "rate", "datatype": dbt_utils.type_float()},
    {"name": "title", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_shopify_tender_transaction_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "amount", "datatype": dbt_utils.type_float()},
    {"name": "currency", "datatype": dbt_utils.type_string()},
    {"name": "id", "datatype": dbt_utils.type_int(), "alias": "transaction_id"},
    {"name": "order_id", "datatype": dbt_utils.type_int()},
    {"name": "payment_method", "datatype": dbt_utils.type_string()},
    {"name": "processed_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "remote_reference", "datatype": dbt_utils.type_string()},
    {"name": "test", "datatype": "boolean"},
    {"name": "user_id", "datatype": dbt_utils.type_int()}
] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_shopify_transaction_columns() %}

{% set columns = [
    {"name": "id", "datatype": dbt_utils.type_numeric(), "alias": "transaction_id"},
    {"name": "order_id", "datatype": dbt_utils.type_numeric()},
    {"name": "refund_id", "datatype": dbt_utils.type_numeric()},
    {"name": "amount", "datatype": dbt_utils.type_numeric()},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "processed_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "device_id", "datatype": dbt_utils.type_numeric()},
    {"name": "gateway", "datatype": dbt_utils.type_string()},
    {"name": "source_name", "datatype": dbt_utils.type_string()},
    {"name": "message", "datatype": dbt_utils.type_string()},
    {"name": "currency", "datatype": dbt_utils.type_string()},
    {"name": "location_id", "datatype": dbt_utils.type_numeric()},
    {"name": "parent_id", "datatype": dbt_utils.type_numeric()},
    {"name": "payment_avs_result_code", "datatype": dbt_utils.type_string()},
    {"name": "payment_credit_card_bin", "datatype": dbt_utils.type_string()},
    {"name": "payment_cvv_result_code", "datatype": dbt_utils.type_string()},
    {"name": "payment_credit_card_number", "datatype": dbt_utils.type_string()},
    {"name": "payment_credit_card_company", "datatype": dbt_utils.type_string()},
    {"name": "kind", "datatype": dbt_utils.type_string()},
    {"name": "receipt", "datatype": dbt_utils.type_string()},
    {"name": "currency_exchange_id", "datatype": dbt_utils.type_numeric()},
    {"name": "currency_exchange_adjustment", "datatype": dbt_utils.type_numeric()},
    {"name": "currency_exchange_original_amount", "datatype": dbt_utils.type_numeric()},
    {"name": "currency_exchange_final_amount", "datatype": dbt_utils.type_numeric()},
    {"name": "currency_exchange_currency", "datatype": dbt_utils.type_string()},
    {"name": "error_code", "datatype": dbt_utils.type_string()},
    {"name": "status", "datatype": dbt_utils.type_string()},
    {"name": "test", "datatype": "boolean"},
    {"name": "user_id", "datatype": dbt_utils.type_numeric()},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "authorization_expires_at", "datatype": dbt_utils.type_timestamp()}
] %}

{% if target.type in ('redshift','postgres') %}
 {{ columns.append({"name": "authorization", "datatype": dbt_utils.type_string(), "quote": True, "alias": "authorization_code"}) }}
{% else %}
 {{ columns.append({"name": "authorization", "datatype": dbt_utils.type_string(), "alias": "authorization_code"}) }}
{% endif %}

{{ return(columns) }}

{% endmacro %}

{% macro get_shopify_customer_tag_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "index", "datatype": dbt_utils.type_int()},
    {"name": "customer_id", "datatype": dbt_utils.type_int()},
    {"name": "value", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_shopify_tax_line_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "index", "datatype": dbt_utils.type_int()},
    {"name": "order_line_id", "datatype": dbt_utils.type_int()},
    {"name": "price", "datatype": dbt_utils.type_float()},
    {"name": "price_set", "datatype": dbt_utils.type_string()},
    {"name": "rate", "datatype": dbt_utils.type_float()},
    {"name": "title", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_shopify_order_tag_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "index", "datatype": dbt_utils.type_int()},
    {"name": "order_id", "datatype": dbt_utils.type_int()},
    {"name": "value", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_shopify_order_url_tag_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "key", "datatype": dbt_utils.type_string()},
    {"name": "order_id", "datatype": dbt_utils.type_int()},
    {"name": "value", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_shopify_fulfillment_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "id", "datatype": dbt_utils.type_int(), "alias": "fulfillment_id"},
    {"name": "location_id", "datatype": dbt_utils.type_int()},
    {"name": "name", "datatype": dbt_utils.type_string()},
    {"name": "order_id", "datatype": dbt_utils.type_int()},
    {"name": "service", "datatype": dbt_utils.type_string()},
    {"name": "shipment_status", "datatype": dbt_utils.type_string()},
    {"name": "status", "datatype": dbt_utils.type_string()},
    {"name": "tracking_company", "datatype": dbt_utils.type_string()},
    {"name": "tracking_number", "datatype": dbt_utils.type_string()},
    {"name": "tracking_numbers", "datatype": dbt_utils.type_string()},
    {"name": "tracking_urls", "datatype": dbt_utils.type_string()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_shopify_order_discount_code_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "amount", "datatype": dbt_utils.type_float()},
    {"name": "code", "datatype": dbt_utils.type_string()},
    {"name": "index", "datatype": dbt_utils.type_int()},
    {"name": "order_id", "datatype": dbt_utils.type_int()},
    {"name": "type", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_shopify_fulfillment_event_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "address_1", "datatype": dbt_utils.type_string()},
    {"name": "city", "datatype": dbt_utils.type_string()},
    {"name": "country", "datatype": dbt_utils.type_string()},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "estimated_delivery_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "fulfillment_id", "datatype": dbt_utils.type_int()},
    {"name": "happened_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "id", "datatype": dbt_utils.type_int()},
    {"name": "latitude", "datatype": dbt_utils.type_float()},
    {"name": "longitude", "datatype": dbt_utils.type_float()},
    {"name": "message", "datatype": dbt_utils.type_string()},
    {"name": "order_id", "datatype": dbt_utils.type_int()},
    {"name": "province", "datatype": dbt_utils.type_string()},
    {"name": "shop_id", "datatype": dbt_utils.type_int()},
    {"name": "status", "datatype": dbt_utils.type_string()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "zip", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_shopify_product_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "handle", "datatype": dbt_utils.type_string()},
    {"name": "id", "datatype": dbt_utils.type_numeric(), "alias": "product_id"},
    {"name": "product_type", "datatype": dbt_utils.type_string()},
    {"name": "published_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "published_scope", "datatype": dbt_utils.type_string()},
    {"name": "title", "datatype": dbt_utils.type_string()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "vendor", "datatype": dbt_utils.type_string()},
    {"name": "status", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_shopify_product_image_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "height", "datatype": dbt_utils.type_int()},
    {"name": "id", "datatype": dbt_utils.type_int(), "alias": "product_image_id"},
    {"name": "position", "datatype": dbt_utils.type_int()},
    {"name": "product_id", "datatype": dbt_utils.type_int()},
    {"name": "src", "datatype": dbt_utils.type_string()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "variant_ids", "datatype": dbt_utils.type_string()},
    {"name": "width", "datatype": dbt_utils.type_int()}
] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_shopify_product_tag_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "index", "datatype": dbt_utils.type_int()},
    {"name": "product_id", "datatype": dbt_utils.type_int()},
    {"name": "value", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_shopify_product_variant_columns() %}

{% set columns = [
    {"name": "id", "datatype": dbt_utils.type_numeric(), "alias": "product_variant_id"},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "product_id", "datatype": dbt_utils.type_numeric()},
    {"name": "inventory_item_id", "datatype": dbt_utils.type_numeric()},
    {"name": "image_id", "datatype": dbt_utils.type_numeric()},
    {"name": "title", "datatype": dbt_utils.type_string()},
    {"name": "price", "datatype": dbt_utils.type_float()},
    {"name": "sku", "datatype": dbt_utils.type_string()},
    {"name": "position", "datatype": dbt_utils.type_numeric()},
    {"name": "inventory_policy", "datatype": dbt_utils.type_string()},
    {"name": "compare_at_price", "datatype": dbt_utils.type_float()},
    {"name": "fulfillment_service", "datatype": dbt_utils.type_string()},
    {"name": "inventory_management", "datatype": dbt_utils.type_string()},
    {"name": "taxable", "datatype": "boolean", "alias": "is_taxable"},
    {"name": "barcode", "datatype": dbt_utils.type_string()},
    {"name": "grams", "datatype": dbt_utils.type_float()},
    {"name": "old_inventory_quantity", "datatype": dbt_utils.type_numeric()},
    {"name": "inventory_quantity", "datatype": dbt_utils.type_numeric()},
    {"name": "weight", "datatype": dbt_utils.type_float()},
    {"name": "weight_unit", "datatype": dbt_utils.type_string()},
    {"name": "option_1", "datatype": dbt_utils.type_string()},
    {"name": "option_2", "datatype": dbt_utils.type_string()},
    {"name": "option_3", "datatype": dbt_utils.type_string()},
    {"name": "tax_code", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}

