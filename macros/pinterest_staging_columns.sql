{% macro get_pinterest_ads_ad_group_history_columns() %}

{% set columns = [

    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "campaign_id", "datatype": dbt_utils.type_string()},
    {"name": "created_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "end_time", "datatype": dbt_utils.type_timestamp(), "alias": "end_timestamp"},
    {"name": "id", "datatype": dbt_utils.type_string(), "alias": "ad_group_id"},
    {"name": "name", "datatype": dbt_utils.type_string()},
    {"name": "start_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "status", "datatype": dbt_utils.type_string()}

] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_pinterest_ads_campaign_history_columns() %}

{% set columns = [

    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "created_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "id", "datatype": dbt_utils.type_string(), "alias": "campaign_id"},
    {"name": "name", "datatype": dbt_utils.type_string()},
    {"name": "status", "datatype": dbt_utils.type_string()}

] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_pinterest_ads_pin_promotion_history_columns() %}

{% set columns = [

    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "ad_group_id", "datatype": dbt_utils.type_string()},
    {"name": "android_deep_link", "datatype": dbt_utils.type_string()},
    {"name": "click_tracking_url", "datatype": dbt_utils.type_string()},
    {"name": "created_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "creative_type", "datatype": dbt_utils.type_string()},
    {"name": "destination_url", "datatype": dbt_utils.type_string()},
    {"name": "id", "datatype": dbt_utils.type_string(), "alias": "pin_promotion_id"},
    {"name": "ios_deep_link", "datatype": dbt_utils.type_string()},
    {"name": "is_pin_deleted", "datatype": "boolean"},
    {"name": "is_removable", "datatype": "boolean"},
    {"name": "name", "datatype": dbt_utils.type_string()},
    {"name": "pin_id", "datatype": dbt_utils.type_string()},
    {"name": "review_status", "datatype": dbt_utils.type_string()},
    {"name": "status", "datatype": dbt_utils.type_string()},
    {"name": "updated_time", "datatype": dbt_utils.type_timestamp()},
    {"name": "view_tracking_url", "datatype": dbt_utils.type_string()}

] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_pinterest_ads_pin_promotion_report_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "ad_group_id", "datatype": dbt_utils.type_string()},
    {"name": "advertiser_id", "datatype": dbt_utils.type_string()},
    {"name": "campaign_id", "datatype": dbt_utils.type_string()},
    {"name": "clickthrough_1", "datatype": dbt_utils.type_numeric()},
    {"name": "clickthrough_1_gross", "datatype": dbt_utils.type_numeric()},
    {"name": "clickthrough_2", "datatype": dbt_utils.type_numeric()},
    {"name": "closeup_1", "datatype": dbt_utils.type_numeric()},
    {"name": "closeup_2", "datatype": dbt_utils.type_numeric()},
    {"name": "cpcv_in_micro_dollar", "datatype": dbt_utils.type_float()},
    {"name": "cpcv_p_95_in_micro_dollar", "datatype": dbt_utils.type_float()},
    {"name": "cpv_in_micro_dollar", "datatype": dbt_utils.type_float()},
    {"name": "date", "datatype": dbt_utils.type_timestamp()},
    {"name": "engagement_1", "datatype": dbt_utils.type_numeric()},
    {"name": "engagement_2", "datatype": dbt_utils.type_numeric()},
    {"name": "impression_1", "datatype": dbt_utils.type_numeric()},
    {"name": "impression_1_gross", "datatype": dbt_utils.type_numeric()},
    {"name": "impression_2", "datatype": dbt_utils.type_numeric()},
    {"name": "pin_id", "datatype": dbt_utils.type_numeric()},
    {"name": "pin_promotion_id", "datatype": dbt_utils.type_string()},
    {"name": "repin_1", "datatype": dbt_utils.type_numeric()},
    {"name": "repin_2", "datatype": dbt_utils.type_numeric()},
    {"name": "spend_in_micro_dollar", "datatype": dbt_utils.type_numeric()},
    {"name": "total_click_unknown", "datatype": dbt_utils.type_numeric()},
    {"name": "total_conversions", "datatype": dbt_utils.type_numeric()},
    {"name": "total_impression_frequency", "datatype": dbt_utils.type_float()},
    {"name": "total_impression_user", "datatype": dbt_utils.type_numeric()},
    {"name": "total_unknown_tablet_action_to_mobile_conversion", "datatype": dbt_utils.type_numeric()},
    {"name": "video_avg_watchtime_in_second_1", "datatype": dbt_utils.type_float()},
    {"name": "video_avg_watchtime_in_second_2", "datatype": dbt_utils.type_float()},
    {"name": "video_mrc_views_1", "datatype": dbt_utils.type_numeric()},
    {"name": "video_mrc_views_2", "datatype": dbt_utils.type_numeric()},
    {"name": "video_p_0_combined_1", "datatype": dbt_utils.type_numeric()},
    {"name": "video_p_0_combined_2", "datatype": dbt_utils.type_numeric()},
    {"name": "video_p_100_complete_1", "datatype": dbt_utils.type_numeric()},
    {"name": "video_p_100_complete_2", "datatype": dbt_utils.type_numeric()},
    {"name": "video_p_25_combined_1", "datatype": dbt_utils.type_numeric()},
    {"name": "video_p_25_combined_2", "datatype": dbt_utils.type_numeric()},
    {"name": "video_p_50_combined_1", "datatype": dbt_utils.type_numeric()},
    {"name": "video_p_50_combined_2", "datatype": dbt_utils.type_numeric()},
    {"name": "video_p_75_combined_1", "datatype": dbt_utils.type_numeric()},
    {"name": "video_p_75_combined_2", "datatype": dbt_utils.type_numeric()},
    {"name": "video_p_95_combined_1", "datatype": dbt_utils.type_numeric()},
    {"name": "video_p_95_combined_2", "datatype": dbt_utils.type_numeric()}
] %}

{{ return(columns) }}

{% endmacro %}
