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
