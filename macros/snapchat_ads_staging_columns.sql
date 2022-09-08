{% macro get_snapchat_ads_ad_account_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "advertiser", "datatype": dbt_utils.type_string()},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "currency", "datatype": dbt_utils.type_string()},
    {"name": "id", "datatype": dbt_utils.type_string(), "alias": "ad_account_id"},
    {"name": "lifetime_spend_cap_micro", "datatype": dbt_utils.type_numeric()},
    {"name": "name", "datatype": dbt_utils.type_string(), "alias": "ad_account_name"},
    {"name": "organization_id", "datatype": dbt_utils.type_string()},
    {"name": "status", "datatype": dbt_utils.type_string()},
    {"name": "timezone", "datatype": dbt_utils.type_string()},
    {"name": "type", "datatype": dbt_utils.type_string()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_snapchat_ads_ad_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "ad_squad_id", "datatype": dbt_utils.type_string()},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "creative_id", "datatype": dbt_utils.type_string()},
    {"name": "id", "datatype": dbt_utils.type_string(), "alias": "ad_id"},
    {"name": "name", "datatype": dbt_utils.type_string(), "alias": "ad_name"},
    {"name": "review_status", "datatype": dbt_utils.type_string()},
    {"name": "review_status_reason", "datatype": dbt_utils.type_string()},
    {"name": "status", "datatype": dbt_utils.type_string()},
    {"name": "type", "datatype": dbt_utils.type_string()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_snapchat_ads_ad_hourly_report_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "ad_id", "datatype": dbt_utils.type_string()},
    {"name": "android_installs", "datatype": dbt_utils.type_numeric()},
    {"name": "attachment_avg_view_time_millis", "datatype": dbt_utils.type_numeric()},
    {"name": "attachment_frequency", "datatype": dbt_utils.type_numeric()},
    {"name": "attachment_quartile_1", "datatype": dbt_utils.type_numeric()},
    {"name": "attachment_quartile_2", "datatype": dbt_utils.type_numeric()},
    {"name": "attachment_quartile_3", "datatype": dbt_utils.type_numeric()},
    {"name": "attachment_total_view_time_millis", "datatype": dbt_utils.type_numeric()},
    {"name": "attachment_uniques", "datatype": dbt_utils.type_numeric()},
    {"name": "attachment_view_completion", "datatype": dbt_utils.type_numeric()},
    {"name": "avg_screen_time_millis", "datatype": dbt_utils.type_numeric()},
    {"name": "avg_view_time_millis", "datatype": dbt_utils.type_numeric()},
    {"name": "conversion_add_billing", "datatype": dbt_utils.type_numeric()},
    {"name": "conversion_add_cart", "datatype": dbt_utils.type_numeric()},
    {"name": "conversion_app_opens", "datatype": dbt_utils.type_numeric()},
    {"name": "conversion_level_completes", "datatype": dbt_utils.type_numeric()},
    {"name": "conversion_page_views", "datatype": dbt_utils.type_numeric()},
    {"name": "conversion_purchases", "datatype": dbt_utils.type_numeric()},
    {"name": "conversion_purchases_value", "datatype": dbt_utils.type_numeric()},
    {"name": "conversion_save", "datatype": dbt_utils.type_numeric()},
    {"name": "conversion_searches", "datatype": dbt_utils.type_numeric()},
    {"name": "conversion_sign_ups", "datatype": dbt_utils.type_numeric()},
    {"name": "conversion_start_checkout", "datatype": dbt_utils.type_numeric()},
    {"name": "conversion_view_content", "datatype": dbt_utils.type_numeric()},
    {"name": "date", "datatype": dbt_utils.type_timestamp(), "alias": "date_hour"},
    {"name": "frequency", "datatype": dbt_utils.type_numeric()},
    {"name": "impressions", "datatype": dbt_utils.type_numeric()},
    {"name": "ios_installs", "datatype": dbt_utils.type_numeric()},
    {"name": "quartile_1", "datatype": dbt_utils.type_numeric()},
    {"name": "quartile_2", "datatype": dbt_utils.type_numeric()},
    {"name": "quartile_3", "datatype": dbt_utils.type_numeric()},
    {"name": "saves", "datatype": dbt_utils.type_numeric()},
    {"name": "screen_time_millis", "datatype": dbt_utils.type_numeric()},
    {"name": "shares", "datatype": dbt_utils.type_numeric()},
    {"name": "spend", "datatype": dbt_utils.type_numeric()},
    {"name": "story_completes", "datatype": dbt_utils.type_numeric()},
    {"name": "story_opens", "datatype": dbt_utils.type_numeric()},
    {"name": "swipe_up_percent", "datatype": dbt_utils.type_numeric()},
    {"name": "swipes", "datatype": dbt_utils.type_numeric()},
    {"name": "total_installs", "datatype": dbt_utils.type_numeric()},
    {"name": "uniques", "datatype": dbt_utils.type_numeric()},
    {"name": "video_views", "datatype": dbt_utils.type_numeric()},
    {"name": "view_completion", "datatype": dbt_utils.type_numeric()},
    {"name": "view_time_millis", "datatype": dbt_utils.type_numeric()}
] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_snapchat_ads_ad_squad_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "audience_size_maximum", "datatype": dbt_utils.type_numeric()},
    {"name": "audience_size_minimum", "datatype": dbt_utils.type_numeric()},
    {"name": "auto_bid", "datatype": "boolean"},
    {"name": "bid_estimate_maximum", "datatype": dbt_utils.type_numeric()},
    {"name": "bid_estimate_minimum", "datatype": dbt_utils.type_numeric()},
    {"name": "bid_micro", "datatype": dbt_utils.type_numeric()},
    {"name": "billing_event", "datatype": dbt_utils.type_string()},
    {"name": "campaign_id", "datatype": dbt_utils.type_string()},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "daily_budget_snapchat_ads_micro", "datatype": dbt_utils.type_numeric()},
    {"name": "end_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "id", "datatype": dbt_utils.type_string(), "alias": "ad_squad_id"},
    {"name": "lifetime_budget_snapchat_ads_micro", "datatype": dbt_utils.type_numeric()},
    {"name": "lifetime_spend_micro", "datatype": dbt_utils.type_numeric()},
    {"name": "name", "datatype": dbt_utils.type_string(), "alias": "ad_squad_name"},
    {"name": "optimization_goal", "datatype": dbt_utils.type_string()},
    {"name": "placement", "datatype": dbt_utils.type_string()},
    {"name": "start_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "status", "datatype": dbt_utils.type_string()},
    {"name": "targeting_regulated_content", "datatype": "boolean"},
    {"name": "type", "datatype": dbt_utils.type_string()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_snapchat_ads_campaign_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "ad_account_id", "datatype": dbt_utils.type_string()},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "daily_budget_snapchat_ads_micro", "datatype": dbt_utils.type_numeric()},
    {"name": "end_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "id", "datatype": dbt_utils.type_string(), "alias": "campaign_id"},
    {"name": "lifetime_spend_cap_micro", "datatype": dbt_utils.type_numeric()},
    {"name": "name", "datatype": dbt_utils.type_string(), "alias": "campaign_name"},
    {"name": "objective", "datatype": dbt_utils.type_string()},
    {"name": "start_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "status", "datatype": dbt_utils.type_string()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_snapchat_ads_creative_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "ad_account_id", "datatype": dbt_utils.type_string()},
    {"name": "ad_product", "datatype": dbt_utils.type_string()},
    {"name": "app_install_android_app_url", "datatype": dbt_utils.type_string()},
    {"name": "app_install_app_name", "datatype": dbt_utils.type_string()},
    {"name": "app_install_icon_media_id", "datatype": dbt_utils.type_string()},
    {"name": "app_install_ios_app_id", "datatype": dbt_utils.type_string()},
    {"name": "attachment_type", "datatype": dbt_utils.type_string()},
    {"name": "brand_name", "datatype": dbt_utils.type_string()},
    {"name": "call_to_action", "datatype": dbt_utils.type_string()},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "deep_link_android_app_url", "datatype": dbt_utils.type_string()},
    {"name": "deep_link_app_name", "datatype": dbt_utils.type_string()},
    {"name": "deep_link_icon_media_id", "datatype": dbt_utils.type_string()},
    {"name": "deep_link_ios_app_id", "datatype": dbt_utils.type_string()},
    {"name": "deep_link_uri", "datatype": dbt_utils.type_string()},
    {"name": "headline", "datatype": dbt_utils.type_string()},
    {"name": "id", "datatype": dbt_utils.type_string(), "alias": "creative_id"},
    {"name": "longform_video_media_id", "datatype": dbt_utils.type_string()},
    {"name": "name", "datatype": dbt_utils.type_string(), "alias": "creative_name"},
    {"name": "packaging_status", "datatype": dbt_utils.type_string()},
    {"name": "playback_type", "datatype": dbt_utils.type_string()},
    {"name": "preview_creative_id", "datatype": dbt_utils.type_string()},
    {"name": "review_status", "datatype": dbt_utils.type_string()},
    {"name": "shareable", "datatype": "boolean"},
    {"name": "top_snap_crop_position", "datatype": dbt_utils.type_string()},
    {"name": "top_snap_media_id", "datatype": dbt_utils.type_string()},
    {"name": "type", "datatype": dbt_utils.type_string()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "web_view_allow_snap_javascript_sdk", "datatype": "boolean"},
    {"name": "web_view_block_preload", "datatype": "boolean"},
    {"name": "web_view_url", "datatype": dbt_utils.type_string(), "alias": "url"},
    {"name": "web_view_use_immersive_mode", "datatype": "boolean"}
] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_snapchat_ads_creative_url_tag_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "creative_id", "datatype": dbt_utils.type_string()},
    {"name": "key", "datatype": dbt_utils.type_string(), "alias": "param_key"},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "value", "datatype": dbt_utils.type_string(), "alias": "param_value"}
] %}

{{ return(columns) }}

{% endmacro %}
