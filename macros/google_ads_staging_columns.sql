{% macro get_google_ads_account_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "auto_tagging_enabled", "datatype": "boolean"},
    {"name": "currency_code", "datatype": dbt_utils.type_string()},
    {"name": "descriptive_name", "datatype": dbt_utils.type_string(), "alias": "account_name"},
    {"name": "final_url_suffix", "datatype": dbt_utils.type_string()},
    {"name": "hidden", "datatype": "boolean"},
    {"name": "id", "datatype": dbt_utils.type_string(), "alias": "account_id"},
    {"name": "manager", "datatype": "boolean"},
    {"name": "manager_customer_id", "datatype": dbt_utils.type_int()},
    {"name": "optimization_score", "datatype": dbt_utils.type_float()},
    {"name": "pay_per_conversion_eligibility_failure_reasons", "datatype": dbt_utils.type_string()},
    {"name": "test_account", "datatype": "boolean"},
    {"name": "time_zone", "datatype": dbt_utils.type_string()},
    {"name": "tracking_url_template", "datatype": dbt_utils.type_string()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_google_ads_ad_group_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "ad_rotation_mode", "datatype": dbt_utils.type_string()},
    {"name": "base_ad_group_id", "datatype": dbt_utils.type_int()},
    {"name": "campaign_id", "datatype": dbt_utils.type_string()},
    {"name": "campaign_name", "datatype": dbt_utils.type_string()},
    {"name": "display_custom_bid_dimension", "datatype": dbt_utils.type_string()},
    {"name": "explorer_auto_optimizer_setting_opt_in", "datatype": "boolean"},
    {"name": "final_url_suffix", "datatype": dbt_utils.type_string()},
    {"name": "id", "datatype": dbt_utils.type_string(), "alias": "ad_group_id"},
    {"name": "name", "datatype": dbt_utils.type_string(), "alias": "ad_group_name"},
    {"name": "status", "datatype": dbt_utils.type_string(), "alias": "ad_group_status"},
    {"name": "target_google_ads_restrictions", "datatype": dbt_utils.type_string()},
    {"name": "tracking_url_template", "datatype": dbt_utils.type_string()},
    {"name": "type", "datatype": dbt_utils.type_string(), "alias": "ad_group_type"},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_google_ads_ad_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "action_items", "datatype": dbt_utils.type_string()},
    {"name": "ad_group_id", "datatype": dbt_utils.type_string()},
    {"name": "ad_strength", "datatype": dbt_utils.type_string()},
    {"name": "added_by_google_ads", "datatype": "boolean"},
    {"name": "device_preference", "datatype": dbt_utils.type_string()},
    {"name": "display_url", "datatype": dbt_utils.type_string()},
    {"name": "final_app_urls", "datatype": dbt_utils.type_string()},
    {"name": "final_mobile_urls", "datatype": dbt_utils.type_string()},
    {"name": "final_url_suffix", "datatype": dbt_utils.type_string()},
    {"name": "final_urls", "datatype": dbt_utils.type_string(), "alias": "source_final_urls"},
    {"name": "id", "datatype": dbt_utils.type_int(), "alias": "ad_id"},
    {"name": "name", "datatype": dbt_utils.type_string()},
    {"name": "policy_summary_approval_status", "datatype": dbt_utils.type_string()},
    {"name": "policy_summary_review_status", "datatype": dbt_utils.type_string()},
    {"name": "status", "datatype": dbt_utils.type_string(), "alias": "ad_status"},
    {"name": "system_managed_resource_source", "datatype": dbt_utils.type_string()},
    {"name": "tracking_url_template", "datatype": dbt_utils.type_string()},
    {"name": "type", "datatype": dbt_utils.type_string(), "alias": "ad_type"},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "url_collections", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_google_ads_ad_stats_columns() %}

{% set columns = [
    {"name": "_fivetran_id", "datatype": dbt_utils.type_string()},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "active_view_impressions", "datatype": dbt_utils.type_int()},
    {"name": "active_view_measurability", "datatype": dbt_utils.type_float()},
    {"name": "active_view_measurable_cost_micros", "datatype": dbt_utils.type_int()},
    {"name": "active_view_measurable_impressions", "datatype": dbt_utils.type_int()},
    {"name": "active_view_viewability", "datatype": dbt_utils.type_float()},
    {"name": "ad_group", "datatype": dbt_utils.type_string(), "alias": "ad_group_id"},
    {"name": "ad_group_base_ad_group", "datatype": dbt_utils.type_string()},
    {"name": "ad_id", "datatype": dbt_utils.type_int()},
    {"name": "ad_network_type", "datatype": dbt_utils.type_string()},
    {"name": "campaign_base_campaign", "datatype": dbt_utils.type_string()},
    {"name": "campaign_id", "datatype": dbt_utils.type_string()},
    {"name": "clicks", "datatype": dbt_utils.type_int()},
    {"name": "conversions", "datatype": dbt_utils.type_float()},
    {"name": "conversions_value", "datatype": dbt_utils.type_float()},
    {"name": "cost_micros", "datatype": dbt_utils.type_int()},
    {"name": "customer_id", "datatype": dbt_utils.type_string(), "alias": "account_id"},
    {"name": "date", "datatype": "date", "alias": "date_day"},
    {"name": "device", "datatype": dbt_utils.type_string()},
    {"name": "impressions", "datatype": dbt_utils.type_int()},
    {"name": "interaction_event_types", "datatype": dbt_utils.type_string()},
    {"name": "interactions", "datatype": dbt_utils.type_int()},
    {"name": "keyword_ad_group_criterion", "datatype": dbt_utils.type_string()},
    {"name": "view_through_conversions", "datatype": dbt_utils.type_int()}
] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_google_ads_campaign_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "ad_serving_optimization_status", "datatype": dbt_utils.type_string()},
    {"name": "advertising_channel_subtype", "datatype": dbt_utils.type_string()},
    {"name": "advertising_channel_type", "datatype": dbt_utils.type_string()},
    {"name": "base_campaign_id", "datatype": dbt_utils.type_int()},
    {"name": "customer_id", "datatype": dbt_utils.type_string(), "alias": "account_id"},
    {"name": "end_date", "datatype": dbt_utils.type_string()},
    {"name": "experiment_type", "datatype": dbt_utils.type_string()},
    {"name": "final_url_suffix", "datatype": dbt_utils.type_string()},
    {"name": "frequency_caps", "datatype": dbt_utils.type_string()},
    {"name": "id", "datatype": dbt_utils.type_string(), "alias": "campaign_id"},
    {"name": "name", "datatype": dbt_utils.type_string(), "alias": "campaign_name"},
    {"name": "optimization_score", "datatype": dbt_utils.type_float()},
    {"name": "payment_mode", "datatype": dbt_utils.type_string()},
    {"name": "serving_status", "datatype": dbt_utils.type_string()},
    {"name": "start_date", "datatype": dbt_utils.type_string()},
    {"name": "status", "datatype": dbt_utils.type_string()},
    {"name": "tracking_url_template", "datatype": dbt_utils.type_string()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "vanity_pharma_display_url_mode", "datatype": dbt_utils.type_string()},
    {"name": "vanity_pharma_text", "datatype": dbt_utils.type_string()},
    {"name": "video_brand_safety_suitability", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}

