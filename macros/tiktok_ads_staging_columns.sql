{% macro get_tiktok_ads_adgroup_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "action_days", "datatype": dbt_utils.type_numeric()},
    {"name": "adgroup_id", "datatype": dbt_utils.type_string(), "alias": "ad_group_id"},
    {"name": "adgroup_name", "datatype": dbt_utils.type_string()},
    {"name": "advertiser_id", "datatype": dbt_utils.type_string()},
    {"name": "android_osv", "datatype": dbt_utils.type_string()},
    {"name": "app_download_url", "datatype": dbt_utils.type_string()},
    {"name": "app_id", "datatype": dbt_utils.type_numeric()},
    {"name": "app_name", "datatype": dbt_utils.type_string()},
    {"name": "app_type", "datatype": dbt_utils.type_string()},
    {"name": "audience_type", "datatype": dbt_utils.type_string()},
    {"name": "bid", "datatype": dbt_utils.type_float()},
    {"name": "bid_type", "datatype": dbt_utils.type_string()},
    {"name": "billing_event", "datatype": dbt_utils.type_string()},
    {"name": "budget", "datatype": dbt_utils.type_float()},
    {"name": "budget_mode", "datatype": dbt_utils.type_string()},
    {"name": "campaign_id", "datatype": dbt_utils.type_string()},
    {"name": "category", "datatype": dbt_utils.type_numeric()},
    {"name": "click_tracking_url", "datatype": dbt_utils.type_string()},
    {"name": "conversion_bid", "datatype": dbt_utils.type_float()},
    {"name": "cpv_video_duration", "datatype": dbt_utils.type_string()},
    {"name": "create_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "creative_material_mode", "datatype": dbt_utils.type_string()},
    {"name": "dayparting", "datatype": dbt_utils.type_string()},
    {"name": "deep_bid_type", "datatype": dbt_utils.type_string()},
    {"name": "deep_cpabid", "datatype": dbt_utils.type_float()},
    {"name": "deep_external_action", "datatype": dbt_utils.type_string()},
    {"name": "display_name", "datatype": dbt_utils.type_string()},
    {"name": "enable_inventory_filter", "datatype": "boolean"},
    {"name": "external_action", "datatype": dbt_utils.type_string()},
    {"name": "fallback_type", "datatype": dbt_utils.type_string()},
    {"name": "frequency", "datatype": dbt_utils.type_numeric()},
    {"name": "frequency_schedule", "datatype": dbt_utils.type_numeric()},
    {"name": "gender", "datatype": dbt_utils.type_string()},
    {"name": "impression_tracking_url", "datatype": dbt_utils.type_string()},
    {"name": "ios_osv", "datatype": dbt_utils.type_string()},
    {"name": "is_comment_disable", "datatype": dbt_utils.type_numeric()},
    {"name": "is_hfss", "datatype": "boolean"},
    {"name": "is_new_structure", "datatype": "boolean"},
    {"name": "landing_page_url", "datatype": dbt_utils.type_string()},
    {"name": "open_url", "datatype": dbt_utils.type_string()},
    {"name": "open_url_type", "datatype": dbt_utils.type_string()},
    {"name": "opt_status", "datatype": dbt_utils.type_string()},
    {"name": "optimize_goal", "datatype": dbt_utils.type_string()},
    {"name": "pacing", "datatype": dbt_utils.type_string()},
    {"name": "package", "datatype": dbt_utils.type_string()},
    {"name": "pixel_id", "datatype": dbt_utils.type_numeric()},
    {"name": "placement_type", "datatype": dbt_utils.type_string()},
    {"name": "profile_image", "datatype": dbt_utils.type_string()},
    {"name": "schedule_end_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "schedule_start_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "schedule_type", "datatype": dbt_utils.type_string()},
    {"name": "skip_learning_phase", "datatype": dbt_utils.type_numeric()},
    {"name": "statistic_type", "datatype": dbt_utils.type_string()},
    {"name": "status", "datatype": dbt_utils.type_string()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "video_download", "datatype": dbt_utils.type_string()},
    {"name": "audience", "datatype": dbt_utils.type_string()},
    {"name": "excluded_audience", "datatype": dbt_utils.type_string()},
    {"name": "location", "datatype": dbt_utils.type_string()},
    {"name": "interest_category_v_2", "datatype": dbt_utils.type_string()},
    {"name": "pangle_block_app_list_id", "datatype": dbt_utils.type_string()},
    {"name": "action_categories", "datatype": dbt_utils.type_string()},
    {"name": "placement", "datatype": dbt_utils.type_string()},
    {"name": "keywords", "datatype": dbt_utils.type_string()},
    {"name": "age", "datatype": dbt_utils.type_string()},
    {"name": "languages", "datatype": dbt_utils.type_string()}

] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_tiktok_ads_group_report_hourly_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "adgroup_id", "datatype": dbt_utils.type_numeric()},
    {"name": "average_video_play", "datatype": dbt_utils.type_float()},
    {"name": "average_video_play_per_user", "datatype": dbt_utils.type_float()},
    {"name": "clicks", "datatype": dbt_utils.type_numeric()},
    {"name": "comments", "datatype": dbt_utils.type_numeric()},
    {"name": "conversion", "datatype": dbt_utils.type_numeric()},
    {"name": "conversion_rate", "datatype": dbt_utils.type_float()},
    {"name": "cost_per_1000_reached", "datatype": dbt_utils.type_float()},
    {"name": "cost_per_conversion", "datatype": dbt_utils.type_float()},
    {"name": "cost_per_result", "datatype": dbt_utils.type_float()},
    {"name": "cost_per_secondary_goal_result", "datatype": dbt_utils.type_string()},
    {"name": "cpc", "datatype": dbt_utils.type_float()},
    {"name": "cpm", "datatype": dbt_utils.type_float()},
    {"name": "ctr", "datatype": dbt_utils.type_float()},
    {"name": "follows", "datatype": dbt_utils.type_numeric()},
    {"name": "impressions", "datatype": dbt_utils.type_numeric()},
    {"name": "likes", "datatype": dbt_utils.type_numeric()},
    {"name": "profile_visits", "datatype": dbt_utils.type_numeric()},
    {"name": "profile_visits_rate", "datatype": dbt_utils.type_float()},
    {"name": "reach", "datatype": dbt_utils.type_numeric()},
    {"name": "real_time_conversion", "datatype": dbt_utils.type_numeric()},
    {"name": "real_time_conversion_rate", "datatype": dbt_utils.type_float()},
    {"name": "real_time_cost_per_conversion", "datatype": dbt_utils.type_float()},
    {"name": "real_time_cost_per_result", "datatype": dbt_utils.type_float()},
    {"name": "real_time_result", "datatype": dbt_utils.type_numeric()},
    {"name": "real_time_result_rate", "datatype": dbt_utils.type_float()},
    {"name": "result", "datatype": dbt_utils.type_numeric()},
    {"name": "result_rate", "datatype": dbt_utils.type_float()},
    {"name": "secondary_goal_result", "datatype": dbt_utils.type_string()},
    {"name": "secondary_goal_result_rate", "datatype": dbt_utils.type_string()},
    {"name": "shares", "datatype": dbt_utils.type_numeric()},
    {"name": "spend", "datatype": dbt_utils.type_float()},
    {"name": "stat_time_hour", "datatype": dbt_utils.type_timestamp()},
    {"name": "video_play_actions", "datatype": dbt_utils.type_numeric()},
    {"name": "video_views_p_100", "datatype": dbt_utils.type_numeric()},
    {"name": "video_views_p_25", "datatype": dbt_utils.type_numeric()},
    {"name": "video_views_p_50", "datatype": dbt_utils.type_numeric()},
    {"name": "video_views_p_75", "datatype": dbt_utils.type_numeric()},
    {"name": "video_watched_2_s", "datatype": dbt_utils.type_numeric()},
    {"name": "video_watched_6_s", "datatype": dbt_utils.type_numeric()}
] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_tiktok_ads_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "ad_id", "datatype": dbt_utils.type_numeric()},
    {"name": "ad_name", "datatype": dbt_utils.type_string()},
    {"name": "ad_text", "datatype": dbt_utils.type_string()},
    {"name": "adgroup_id", "datatype": dbt_utils.type_string(), "alias": "ad_group_id"},
    {"name": "advertiser_id", "datatype": dbt_utils.type_string()},
    {"name": "app_name", "datatype": dbt_utils.type_string()},
    {"name": "call_to_action", "datatype": dbt_utils.type_string()},
    {"name": "campaign_id", "datatype": dbt_utils.type_string()},
    {"name": "click_tracking_url", "datatype": dbt_utils.type_string()},
    {"name": "create_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "display_name", "datatype": dbt_utils.type_string()},
    {"name": "impression_tracking_url", "datatype": dbt_utils.type_string()},
    {"name": "is_aco", "datatype": "boolean"},
    {"name": "is_creative_authorized", "datatype": "boolean"},
    {"name": "is_new_structure", "datatype": "boolean"},
    {"name": "landing_page_url", "datatype": dbt_utils.type_string()},
    {"name": "open_url", "datatype": dbt_utils.type_string()},
    {"name": "opt_status", "datatype": dbt_utils.type_string()},
    {"name": "playable_url", "datatype": dbt_utils.type_string()},
    {"name": "profile_image", "datatype": dbt_utils.type_string()},
    {"name": "status", "datatype": dbt_utils.type_string()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "video_id", "datatype": dbt_utils.type_string()},
    {"name": "image_ids", "datatype": dbt_utils.type_string()}

] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_tiktok_ads_report_hourly_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "ad_id", "datatype": dbt_utils.type_numeric()},
    {"name": "average_video_play", "datatype": dbt_utils.type_float()},
    {"name": "average_video_play_per_user", "datatype": dbt_utils.type_float()},
    {"name": "clicks", "datatype": dbt_utils.type_numeric()},
    {"name": "comments", "datatype": dbt_utils.type_numeric()},
    {"name": "conversion", "datatype": dbt_utils.type_numeric()},
    {"name": "conversion_rate", "datatype": dbt_utils.type_float()},
    {"name": "cost_per_1000_reached", "datatype": dbt_utils.type_float()},
    {"name": "cost_per_conversion", "datatype": dbt_utils.type_float()},
    {"name": "cost_per_result", "datatype": dbt_utils.type_float()},
    {"name": "cost_per_secondary_goal_result", "datatype": dbt_utils.type_string()},
    {"name": "cpc", "datatype": dbt_utils.type_float()},
    {"name": "cpm", "datatype": dbt_utils.type_float()},
    {"name": "ctr", "datatype": dbt_utils.type_float()},
    {"name": "follows", "datatype": dbt_utils.type_numeric()},
    {"name": "impressions", "datatype": dbt_utils.type_numeric()},
    {"name": "likes", "datatype": dbt_utils.type_numeric()},
    {"name": "profile_visits", "datatype": dbt_utils.type_numeric()},
    {"name": "profile_visits_rate", "datatype": dbt_utils.type_float()},
    {"name": "reach", "datatype": dbt_utils.type_numeric()},
    {"name": "real_time_conversion", "datatype": dbt_utils.type_numeric()},
    {"name": "real_time_conversion_rate", "datatype": dbt_utils.type_float()},
    {"name": "real_time_cost_per_conversion", "datatype": dbt_utils.type_float()},
    {"name": "real_time_cost_per_result", "datatype": dbt_utils.type_float()},
    {"name": "real_time_result", "datatype": dbt_utils.type_numeric()},
    {"name": "real_time_result_rate", "datatype": dbt_utils.type_float()},
    {"name": "result", "datatype": dbt_utils.type_numeric()},
    {"name": "result_rate", "datatype": dbt_utils.type_float()},
    {"name": "secondary_goal_result", "datatype": dbt_utils.type_string()},
    {"name": "secondary_goal_result_rate", "datatype": dbt_utils.type_string()},
    {"name": "shares", "datatype": dbt_utils.type_numeric()},
    {"name": "spend", "datatype": dbt_utils.type_float()},
    {"name": "stat_time_hour", "datatype": dbt_utils.type_timestamp()},
    {"name": "video_play_actions", "datatype": dbt_utils.type_numeric()},
    {"name": "video_views_p_100", "datatype": dbt_utils.type_numeric()},
    {"name": "video_views_p_25", "datatype": dbt_utils.type_numeric()},
    {"name": "video_views_p_50", "datatype": dbt_utils.type_numeric()},
    {"name": "video_views_p_75", "datatype": dbt_utils.type_numeric()},
    {"name": "video_watched_2_s", "datatype": dbt_utils.type_numeric()},
    {"name": "video_watched_6_s", "datatype": dbt_utils.type_numeric()}
] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_tiktok_ads_adsvertiser_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "address", "datatype": dbt_utils.type_string()},
    {"name": "balance", "datatype": dbt_utils.type_float()},
    {"name": "company", "datatype": dbt_utils.type_string()},
    {"name": "contacter", "datatype": dbt_utils.type_string()},
    {"name": "country", "datatype": dbt_utils.type_string()},
    {"name": "create_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "currency", "datatype": dbt_utils.type_string()},
    {"name": "description", "datatype": dbt_utils.type_string()},
    {"name": "email", "datatype": dbt_utils.type_string()},
    {"name": "id", "datatype": dbt_utils.type_string(), "alias": "advertiser_id"},
    {"name": "industry", "datatype": dbt_utils.type_string()},
    {"name": "language", "datatype": dbt_utils.type_string()},
    {"name": "license_no", "datatype": dbt_utils.type_string()},
    {"name": "license_url", "datatype": dbt_utils.type_string()},
    {"name": "name", "datatype": dbt_utils.type_string()},
    {"name": "phone_number", "datatype": dbt_utils.type_string()},
    {"name": "promotion_area", "datatype": dbt_utils.type_string()},
    {"name": "reason", "datatype": dbt_utils.type_string()},
    {"name": "role", "datatype": dbt_utils.type_string()},
    {"name": "status", "datatype": dbt_utils.type_string()},
    {"name": "telephone", "datatype": dbt_utils.type_string()},
    {"name": "timezone", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_tiktok_ads_campaign_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "advertiser_id", "datatype": dbt_utils.type_string()},
    {"name": "budget", "datatype": dbt_utils.type_float()},
    {"name": "budget_mode", "datatype": dbt_utils.type_string()},
    {"name": "campaign_id", "datatype": dbt_utils.type_string()},
    {"name": "campaign_name", "datatype": dbt_utils.type_string()},
    {"name": "campaign_type", "datatype": dbt_utils.type_string()},
    {"name": "create_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "is_new_structure", "datatype": dbt_utils.type_string()},
    {"name": "objective_type", "datatype": dbt_utils.type_string()},
    {"name": "opt_status", "datatype": dbt_utils.type_string()},
    {"name": "split_test_variable", "datatype": dbt_utils.type_string()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_tiktok_ads_campaign_report_hourly_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "average_video_play", "datatype": dbt_utils.type_float()},
    {"name": "average_video_play_per_user", "datatype": dbt_utils.type_float()},
    {"name": "campaign_id", "datatype": dbt_utils.type_string()},
    {"name": "clicks", "datatype": dbt_utils.type_numeric()},
    {"name": "comments", "datatype": dbt_utils.type_numeric()},
    {"name": "conversion", "datatype": dbt_utils.type_numeric()},
    {"name": "conversion_rate", "datatype": dbt_utils.type_float()},
    {"name": "cost_per_1000_reached", "datatype": dbt_utils.type_float()},
    {"name": "cost_per_conversion", "datatype": dbt_utils.type_float()},
    {"name": "cost_per_result", "datatype": dbt_utils.type_float()},
    {"name": "cost_per_secondary_goal_result", "datatype": dbt_utils.type_string()},
    {"name": "cpc", "datatype": dbt_utils.type_float()},
    {"name": "cpm", "datatype": dbt_utils.type_float()},
    {"name": "ctr", "datatype": dbt_utils.type_float()},
    {"name": "follows", "datatype": dbt_utils.type_numeric()},
    {"name": "impressions", "datatype": dbt_utils.type_numeric()},
    {"name": "likes", "datatype": dbt_utils.type_numeric()},
    {"name": "profile_visits", "datatype": dbt_utils.type_numeric()},
    {"name": "profile_visits_rate", "datatype": dbt_utils.type_float()},
    {"name": "reach", "datatype": dbt_utils.type_numeric()},
    {"name": "real_time_conversion", "datatype": dbt_utils.type_numeric()},
    {"name": "real_time_conversion_rate", "datatype": dbt_utils.type_float()},
    {"name": "real_time_cost_per_conversion", "datatype": dbt_utils.type_float()},
    {"name": "real_time_cost_per_result", "datatype": dbt_utils.type_float()},
    {"name": "real_time_result", "datatype": dbt_utils.type_numeric()},
    {"name": "real_time_result_rate", "datatype": dbt_utils.type_float()},
    {"name": "result", "datatype": dbt_utils.type_numeric()},
    {"name": "result_rate", "datatype": dbt_utils.type_float()},
    {"name": "secondary_goal_result", "datatype": dbt_utils.type_string()},
    {"name": "secondary_goal_result_rate", "datatype": dbt_utils.type_string()},
    {"name": "shares", "datatype": dbt_utils.type_numeric()},
    {"name": "spend", "datatype": dbt_utils.type_float()},
    {"name": "stat_time_hour", "datatype": dbt_utils.type_timestamp()},
    {"name": "video_play_actions", "datatype": dbt_utils.type_numeric()},
    {"name": "video_views_p_100", "datatype": dbt_utils.type_numeric()},
    {"name": "video_views_p_25", "datatype": dbt_utils.type_numeric()},
    {"name": "video_views_p_50", "datatype": dbt_utils.type_numeric()},
    {"name": "video_views_p_75", "datatype": dbt_utils.type_numeric()},
    {"name": "video_watched_2_s", "datatype": dbt_utils.type_numeric()},
    {"name": "video_watched_6_s", "datatype": dbt_utils.type_numeric()}
] %}

{{ return(columns) }}

{% endmacro %}