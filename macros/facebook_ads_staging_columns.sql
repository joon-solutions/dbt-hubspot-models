{% macro get_facebook_ads_account_history_columns() %}

{% set columns = [
    {"name": "_fivetran_id", "datatype": dbt_utils.type_string()},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "account_status", "datatype": dbt_utils.type_string()},
    {"name": "age", "datatype": dbt_utils.type_float()},
    {"name": "agency_client_declaration_agency_representing_client", "datatype": dbt_utils.type_int()},
    {"name": "agency_client_declaration_client_based_in_france", "datatype": dbt_utils.type_int()},
    {"name": "agency_client_declaration_client_city", "datatype": dbt_utils.type_string()},
    {"name": "agency_client_declaration_client_country_code", "datatype": dbt_utils.type_string()},
    {"name": "agency_client_declaration_client_email_address", "datatype": dbt_utils.type_string()},
    {"name": "agency_client_declaration_client_name", "datatype": dbt_utils.type_string()},
    {"name": "agency_client_declaration_client_postal_code", "datatype": dbt_utils.type_string()},
    {"name": "agency_client_declaration_client_province", "datatype": dbt_utils.type_string()},
    {"name": "agency_client_declaration_client_street", "datatype": dbt_utils.type_string()},
    {"name": "agency_client_declaration_client_street_2", "datatype": dbt_utils.type_string()},
    {"name": "agency_client_declaration_has_written_mandate_from_advertiser", "datatype": dbt_utils.type_int()},
    {"name": "agency_client_declaration_is_client_paying_invoices", "datatype": dbt_utils.type_int()},
    {"name": "amount_spent", "datatype": dbt_utils.type_int()},
    {"name": "balance", "datatype": dbt_utils.type_int()},
    {"name": "business_city", "datatype": dbt_utils.type_string()},
    {"name": "business_country_code", "datatype": dbt_utils.type_string()},
    {"name": "business_manager_created_by", "datatype": dbt_utils.type_string()},
    {"name": "business_manager_created_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "business_manager_manager_id", "datatype": dbt_utils.type_int()},
    {"name": "business_manager_name", "datatype": dbt_utils.type_string()},
    {"name": "business_manager_primary_page", "datatype": dbt_utils.type_string()},
    {"name": "business_manager_timezone_id", "datatype": dbt_utils.type_int()},
    {"name": "business_manager_update_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "business_manager_updated_by", "datatype": dbt_utils.type_string()},
    {"name": "business_name", "datatype": dbt_utils.type_string()},
    {"name": "business_state", "datatype": dbt_utils.type_string()},
    {"name": "business_street", "datatype": dbt_utils.type_string()},
    {"name": "business_street_2", "datatype": dbt_utils.type_string()},
    {"name": "business_zip", "datatype": dbt_utils.type_string()},
    {"name": "can_create_brand_lift_study", "datatype": "boolean"},
    {"name": "capabilities", "datatype": dbt_utils.type_string()},
    {"name": "created_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "currency", "datatype": dbt_utils.type_string()},
    {"name": "disable_reason", "datatype": dbt_utils.type_string()},
    {"name": "end_advertiser", "datatype": dbt_utils.type_int()},
    {"name": "end_advertiser_name", "datatype": dbt_utils.type_string()},
    {"name": "has_migrated_permissions", "datatype": "boolean"},
    {"name": "id", "datatype": dbt_utils.type_string(), "alias": "account_id"},
    {"name": "io_number", "datatype": dbt_utils.type_int()},
    {"name": "is_attribution_spec_system_default", "datatype": "boolean"},
    {"name": "is_direct_deals_enabled", "datatype": "boolean"},
    {"name": "is_notifications_enabled", "datatype": "boolean"},
    {"name": "is_personal", "datatype": dbt_utils.type_int()},
    {"name": "is_prepay_account", "datatype": "boolean"},
    {"name": "is_tax_id_required", "datatype": "boolean"},
    {"name": "media_agency", "datatype": dbt_utils.type_int()},
    {"name": "min_campaign_group_spend_cap", "datatype": dbt_utils.type_int()},
    {"name": "min_daily_budget", "datatype": dbt_utils.type_int()},
    {"name": "name", "datatype": dbt_utils.type_string(), "alias": "account_name"},
    {"name": "next_bill_date", "datatype": dbt_utils.type_timestamp()},
    {"name": "offsite_pixels_tos_accepted", "datatype": "boolean"},
    {"name": "owner", "datatype": dbt_utils.type_int()},
    {"name": "partner", "datatype": dbt_utils.type_int()},
    {"name": "salesforce_invoice_group_id", "datatype": dbt_utils.type_string()},
    {"name": "spend_cap", "datatype": dbt_utils.type_int()},
    {"name": "tax_id", "datatype": dbt_utils.type_string()},
    {"name": "tax_id_status", "datatype": dbt_utils.type_string()},
    {"name": "tax_id_type", "datatype": dbt_utils.type_string()},
    {"name": "timezone_id", "datatype": dbt_utils.type_int()},
    {"name": "timezone_name", "datatype": dbt_utils.type_string()},
    {"name": "timezone_offset_hours_utc", "datatype": dbt_utils.type_float()}
] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_facebook_ads_ad_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "account_id", "datatype": dbt_utils.type_string()},
    {"name": "ad_set_id", "datatype": dbt_utils.type_string()},
    {"name": "ad_source_id", "datatype": dbt_utils.type_int()},
    {"name": "bid_amount", "datatype": dbt_utils.type_int()},
    {"name": "bid_info_actions", "datatype": dbt_utils.type_int()},
    {"name": "bid_type", "datatype": dbt_utils.type_string()},
    {"name": "campaign_id", "datatype": dbt_utils.type_string()},
    {"name": "configured_status", "datatype": dbt_utils.type_string()},
    {"name": "created_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "creative_id", "datatype": dbt_utils.type_string()},
    {"name": "effective_status", "datatype": dbt_utils.type_string()},
    {"name": "global_discriminatory_practices", "datatype": dbt_utils.type_string()},
    {"name": "global_non_functional_landing_page", "datatype": dbt_utils.type_string()},
    {"name": "global_use_of_our_brand_assets", "datatype": dbt_utils.type_string()},
    {"name": "id", "datatype": dbt_utils.type_string(), "alias": "ad_id"},
    {"name": "last_updated_by_app_id", "datatype": dbt_utils.type_string()},
    {"name": "name", "datatype": dbt_utils.type_string(), "alias": "ad_name"},
    {"name": "placement_specific_facebook_discriminatory_practices", "datatype": dbt_utils.type_string()},
    {"name": "placement_specific_facebook_non_functional_landing_page", "datatype": dbt_utils.type_string()},
    {"name": "placement_specific_facebook_use_of_our_brand_assets", "datatype": dbt_utils.type_string()},
    {"name": "placement_specific_instagram_discriminatory_practices", "datatype": dbt_utils.type_string()},
    {"name": "status", "datatype": dbt_utils.type_string()},
    {"name": "updated_time", "datatype": dbt_utils.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_facebook_ads_ad_set_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "account_id", "datatype": dbt_utils.type_string()},
    {"name": "adset_source_id", "datatype": dbt_utils.type_int()},
    {"name": "bid_amount", "datatype": dbt_utils.type_int()},
    {"name": "bid_info_actions", "datatype": dbt_utils.type_int()},
    {"name": "bid_strategy", "datatype": dbt_utils.type_string()},
    {"name": "billing_event", "datatype": dbt_utils.type_string()},
    {"name": "budget_facebook_ads_remaining", "datatype": dbt_utils.type_int()},
    {"name": "campaign_id", "datatype": dbt_utils.type_string()},
    {"name": "configured_status", "datatype": dbt_utils.type_string()},
    {"name": "created_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "daily_budget", "datatype": dbt_utils.type_int()},
    {"name": "destination_type", "datatype": dbt_utils.type_string()},
    {"name": "effective_status", "datatype": dbt_utils.type_string()},
    {"name": "end_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "id", "datatype": dbt_utils.type_string(), "alias": "ad_set_id"},
    {"name": "instagram_actor_id", "datatype": dbt_utils.type_int()},
    {"name": "lifetime_budget", "datatype": dbt_utils.type_int()},
    {"name": "lifetime_imps", "datatype": dbt_utils.type_int()},
    {"name": "name", "datatype": dbt_utils.type_string(), "alias": "ad_set_name"},
    {"name": "optimization_goal", "datatype": dbt_utils.type_string()},
    {"name": "promoted_object_application_id", "datatype": dbt_utils.type_string()},
    {"name": "promoted_object_custom_event_type", "datatype": dbt_utils.type_string()},
    {"name": "promoted_object_event_id", "datatype": dbt_utils.type_int()},
    {"name": "promoted_object_object_store_url", "datatype": dbt_utils.type_string()},
    {"name": "promoted_object_offer_id", "datatype": dbt_utils.type_int()},
    {"name": "promoted_object_page_id", "datatype": dbt_utils.type_int()},
    {"name": "promoted_object_pixel_id", "datatype": dbt_utils.type_int()},
    {"name": "promoted_object_place_page_set_id", "datatype": dbt_utils.type_int()},
    {"name": "promoted_object_product_catalog_id", "datatype": dbt_utils.type_int()},
    {"name": "promoted_object_product_set_id", "datatype": dbt_utils.type_int()},
    {"name": "recurring_budget_facebook_ads_semantics", "datatype": "boolean"},
    {"name": "rf_prediction_id", "datatype": dbt_utils.type_string()},
    {"name": "start_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "status", "datatype": dbt_utils.type_string()},
    {"name": "targeting_age_max", "datatype": dbt_utils.type_int()},
    {"name": "targeting_age_min", "datatype": dbt_utils.type_int()},
    {"name": "targeting_app_install_state", "datatype": dbt_utils.type_string()},
    {"name": "targeting_audience_network_positions", "datatype": dbt_utils.type_string()},
    {"name": "targeting_college_years", "datatype": dbt_utils.type_string()},
    {"name": "targeting_connections", "datatype": dbt_utils.type_string()},
    {"name": "targeting_device_platforms", "datatype": dbt_utils.type_string()},
    {"name": "targeting_education_majors", "datatype": dbt_utils.type_string()},
    {"name": "targeting_education_schools", "datatype": dbt_utils.type_string()},
    {"name": "targeting_education_statuses", "datatype": dbt_utils.type_string()},
    {"name": "targeting_effective_audience_network_positions", "datatype": dbt_utils.type_string()},
    {"name": "targeting_excluded_connections", "datatype": dbt_utils.type_string()},
    {"name": "targeting_excluded_publisher_categories", "datatype": dbt_utils.type_string()},
    {"name": "targeting_excluded_publisher_list_ids", "datatype": dbt_utils.type_string()},
    {"name": "targeting_excluded_user_device", "datatype": dbt_utils.type_string()},
    {"name": "targeting_exclusions", "datatype": dbt_utils.type_string()},
    {"name": "targeting_facebook_positions", "datatype": dbt_utils.type_string()},
    {"name": "targeting_flexible_spec", "datatype": dbt_utils.type_string()},
    {"name": "targeting_friends_of_connections", "datatype": dbt_utils.type_string()},
    {"name": "targeting_geo_locations_countries", "datatype": dbt_utils.type_string()},
    {"name": "targeting_geo_locations_location_types", "datatype": dbt_utils.type_string()},
    {"name": "targeting_instagram_positions", "datatype": dbt_utils.type_string()},
    {"name": "targeting_locales", "datatype": dbt_utils.type_string()},
    {"name": "targeting_publisher_platforms", "datatype": dbt_utils.type_string()},
    {"name": "targeting_user_adclusters", "datatype": dbt_utils.type_string()},
    {"name": "targeting_user_device", "datatype": dbt_utils.type_string()},
    {"name": "targeting_user_os", "datatype": dbt_utils.type_string()},
    {"name": "targeting_wireless_carrier", "datatype": dbt_utils.type_string()},
    {"name": "targeting_work_employers", "datatype": dbt_utils.type_string()},
    {"name": "targeting_work_positions", "datatype": dbt_utils.type_string()},
    {"name": "updated_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "use_new_app_click", "datatype": "boolean"}
] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_facebook_ads_basic_ad_columns() %}

{% set columns = [
    {"name": "_fivetran_id", "datatype": dbt_utils.type_string()},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "account_id", "datatype": dbt_utils.type_string()},
    {"name": "ad_id", "datatype": dbt_utils.type_string()},
    {"name": "ad_name", "datatype": dbt_utils.type_string()},
    {"name": "adset_name", "datatype": dbt_utils.type_string()},
    {"name": "cpc", "datatype": dbt_utils.type_float()},
    {"name": "cpm", "datatype": dbt_utils.type_float()},
    {"name": "ctr", "datatype": dbt_utils.type_float()},
    {"name": "date", "datatype": "date", "alias": "date_day"},
    {"name": "frequency", "datatype": dbt_utils.type_float()},
    {"name": "impressions", "datatype": dbt_utils.type_int()},
    {"name": "inline_link_clicks", "datatype": dbt_utils.type_int(), "alias": "clicks"},
    {"name": "reach", "datatype": dbt_utils.type_int()},
    {"name": "spend", "datatype": dbt_utils.type_float()}
] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_facebook_ads_campaign_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "account_id", "datatype": dbt_utils.type_string()},
    {"name": "boosted_object_id", "datatype": dbt_utils.type_int()},
    {"name": "budget_facebook_ads_rebalance_flag", "datatype": "boolean"},
    {"name": "buying_type", "datatype": dbt_utils.type_string()},
    {"name": "can_create_brand_lift_study", "datatype": "boolean"},
    {"name": "can_use_spend_cap", "datatype": "boolean"},
    {"name": "configured_status", "datatype": dbt_utils.type_string()},
    {"name": "created_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "daily_budget", "datatype": dbt_utils.type_int()},
    {"name": "effective_status", "datatype": dbt_utils.type_string()},
    {"name": "id", "datatype": dbt_utils.type_string(), "alias": "campaign_id"},
    {"name": "name", "datatype": dbt_utils.type_string(), "alias": "campaign_name"},
    {"name": "objective", "datatype": dbt_utils.type_string()},
    {"name": "source_campaign_id", "datatype": dbt_utils.type_int()},
    {"name": "spend_cap", "datatype": dbt_utils.type_int()},
    {"name": "start_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "status", "datatype": dbt_utils.type_string()},
    {"name": "stop_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "updated_time", "datatype": dbt_utils.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_facebook_ads_creative_history_columns() %}

{% set columns = [
    {"name": "_fivetran_id", "datatype": dbt_utils.type_string()},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "account_id", "datatype": dbt_utils.type_string()},
    {"name": "actor_id", "datatype": dbt_utils.type_int()},
    {"name": "applink_treatment", "datatype": dbt_utils.type_string()},
    {"name": "asset_feed_spec_link_urls", "datatype": dbt_utils.type_string()},
    {"name": "body", "datatype": dbt_utils.type_string()},
    {"name": "branded_content_sponsor_page_id", "datatype": dbt_utils.type_int()},
    {"name": "call_to_action_type", "datatype": dbt_utils.type_string()},
    {"name": "carousel_ad_link", "datatype": dbt_utils.type_string()},
    {"name": "effective_instagram_story_id", "datatype": dbt_utils.type_int()},
    {"name": "effective_object_story_id", "datatype": dbt_utils.type_string()},
    {"name": "id", "datatype": dbt_utils.type_string(), "alias": "creative_id"},
    {"name": "image_file", "datatype": dbt_utils.type_string()},
    {"name": "image_hash", "datatype": dbt_utils.type_string()},
    {"name": "image_url", "datatype": dbt_utils.type_string()},
    {"name": "instagram_actor_id", "datatype": dbt_utils.type_int()},
    {"name": "instagram_permalink_url", "datatype": dbt_utils.type_string()},
    {"name": "instagram_story_id", "datatype": dbt_utils.type_int()},
    {"name": "link_og_id", "datatype": dbt_utils.type_int()},
    {"name": "link_url", "datatype": dbt_utils.type_string()},
    {"name": "name", "datatype": dbt_utils.type_string(), "alias": "creative_name"},
    {"name": "object_id", "datatype": dbt_utils.type_int()},
    {"name": "object_story_id", "datatype": dbt_utils.type_string()},
    {"name": "object_story_link_data_app_link_spec_android", "datatype": dbt_utils.type_string()},
    {"name": "object_story_link_data_app_link_spec_ios", "datatype": dbt_utils.type_string()},
    {"name": "object_story_link_data_app_link_spec_ipad", "datatype": dbt_utils.type_string()},
    {"name": "object_story_link_data_app_link_spec_iphone", "datatype": dbt_utils.type_string()},
    {"name": "object_story_link_data_caption", "datatype": dbt_utils.type_string()},
    {"name": "object_story_link_data_child_attachments", "datatype": dbt_utils.type_string()},
    {"name": "object_story_link_data_description", "datatype": dbt_utils.type_string()},
    {"name": "object_story_link_data_link", "datatype": dbt_utils.type_string()},
    {"name": "object_story_link_data_message", "datatype": dbt_utils.type_string()},
    {"name": "object_type", "datatype": dbt_utils.type_string()},
    {"name": "object_url", "datatype": dbt_utils.type_string()},
    {"name": "page_link", "datatype": dbt_utils.type_string()},
    {"name": "page_message", "datatype": dbt_utils.type_string()},
    {"name": "product_set_id", "datatype": dbt_utils.type_int()},
    {"name": "status", "datatype": dbt_utils.type_string()},
    {"name": "template_app_link_spec_android", "datatype": dbt_utils.type_string()},
    {"name": "template_app_link_spec_ios", "datatype": dbt_utils.type_string()},
    {"name": "template_app_link_spec_ipad", "datatype": dbt_utils.type_string()},
    {"name": "template_app_link_spec_iphone", "datatype": dbt_utils.type_string()},
    {"name": "template_caption", "datatype": dbt_utils.type_string()},
    {"name": "template_child_attachments", "datatype": dbt_utils.type_string()},
    {"name": "template_description", "datatype": dbt_utils.type_string()},
    {"name": "template_link", "datatype": dbt_utils.type_string()},
    {"name": "template_message", "datatype": dbt_utils.type_string()},
    {"name": "template_page_link", "datatype": dbt_utils.type_string()},
    {"name": "template_url", "datatype": dbt_utils.type_string()},
    {"name": "thumbnail_url", "datatype": dbt_utils.type_string()},
    {"name": "title", "datatype": dbt_utils.type_string()},
    {"name": "url_tags", "datatype": dbt_utils.type_string()},
    {"name": "use_page_actor_override", "datatype": "boolean"},
    {"name": "video_call_to_action_value_link", "datatype": dbt_utils.type_string()},
    {"name": "video_id", "datatype": dbt_utils.type_int()}
] %}

{{ return(columns) }}

{% endmacro %}
