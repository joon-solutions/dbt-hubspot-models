{% macro get_linkedin_ads_account_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "created_time", "datatype": dbt_utils.type_timestamp(), "alias": "created_at"},
    {"name": "currency", "datatype": dbt_utils.type_string()},
    {"name": "id", "datatype": dbt_utils.type_string(), "alias": "account_id"},
    {"name": "last_modified_time", "datatype": dbt_utils.type_timestamp(), "alias": "last_modified_at"},
    {"name": "name", "datatype": dbt_utils.type_string(), "alias": "account_name"},
    {"name": "version_tag", "datatype": dbt_utils.type_int()}
] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_linkedin_ads_ad_analytics_by_creative_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "action_clicks", "datatype": dbt_utils.type_int()},
    {"name": "ad_unit_clicks", "datatype": dbt_utils.type_int()},
    {"name": "approximate_unique_impressions", "datatype": dbt_utils.type_int()},
    {"name": "card_clicks", "datatype": dbt_utils.type_int()},
    {"name": "card_impressions", "datatype": dbt_utils.type_int()},
    {"name": "clicks", "datatype": dbt_utils.type_int()},
    {"name": "comment_likes", "datatype": dbt_utils.type_int()},
    {"name": "comments", "datatype": dbt_utils.type_int()},
    {"name": "comments_likes", "datatype": dbt_utils.type_int()},
    {"name": "company_page_clicks", "datatype": dbt_utils.type_int()},
    {"name": "conversion_value_in_local_currency", "datatype": dbt_utils.type_numeric()},
    {"name": "cost_in_local_currency", "datatype": dbt_utils.type_numeric()},
    {"name": "cost_in_usd", "datatype": dbt_utils.type_numeric()},
    {"name": "creative_id", "datatype": dbt_utils.type_int()},
    {"name": "day", "datatype": dbt_utils.type_timestamp(), "alias": "date_day"},
    {"name": "external_website_conversions", "datatype": dbt_utils.type_int()},
    {"name": "external_website_post_click_conversions", "datatype": dbt_utils.type_int()},
    {"name": "external_website_post_view_conversions", "datatype": dbt_utils.type_int()},
    {"name": "follows", "datatype": dbt_utils.type_int()},
    {"name": "full_screen_plays", "datatype": dbt_utils.type_int()},
    {"name": "impressions", "datatype": dbt_utils.type_int()},
    {"name": "landing_page_clicks", "datatype": dbt_utils.type_int()},
    {"name": "lead_generation_mail_contact_info_shares", "datatype": dbt_utils.type_int()},
    {"name": "lead_generation_mail_interested_clicks", "datatype": dbt_utils.type_int()},
    {"name": "likes", "datatype": dbt_utils.type_int()},
    {"name": "one_click_lead_form_opens", "datatype": dbt_utils.type_int()},
    {"name": "one_click_leads", "datatype": dbt_utils.type_int()},
    {"name": "opens", "datatype": dbt_utils.type_int()},
    {"name": "other_engagements", "datatype": dbt_utils.type_int()},
    {"name": "shares", "datatype": dbt_utils.type_int()},
    {"name": "text_url_clicks", "datatype": dbt_utils.type_int()},
    {"name": "total_engagements", "datatype": dbt_utils.type_int()},
    {"name": "video_completions", "datatype": dbt_utils.type_int()},
    {"name": "video_first_quartile_completions", "datatype": dbt_utils.type_int()},
    {"name": "video_midpoint_completions", "datatype": dbt_utils.type_int()},
    {"name": "video_starts", "datatype": dbt_utils.type_int()},
    {"name": "video_third_quartile_completions", "datatype": dbt_utils.type_int()},
    {"name": "video_views", "datatype": dbt_utils.type_int()},
    {"name": "viral_card_clicks", "datatype": dbt_utils.type_int()},
    {"name": "viral_card_impressions", "datatype": dbt_utils.type_int()},
    {"name": "viral_clicks", "datatype": dbt_utils.type_int()},
    {"name": "viral_comment_likes", "datatype": dbt_utils.type_int()},
    {"name": "viral_comments", "datatype": dbt_utils.type_int()},
    {"name": "viral_company_page_clicks", "datatype": dbt_utils.type_int()},
    {"name": "viral_external_website_conversions", "datatype": dbt_utils.type_int()},
    {"name": "viral_external_website_post_click_conversions", "datatype": dbt_utils.type_int()},
    {"name": "viral_external_website_post_view_conversions", "datatype": dbt_utils.type_int()},
    {"name": "viral_extrernal_website_conversions", "datatype": dbt_utils.type_int()},
    {"name": "viral_extrernal_website_post_click_conversions", "datatype": dbt_utils.type_int()},
    {"name": "viral_extrernal_website_post_view_conversions", "datatype": dbt_utils.type_int()},
    {"name": "viral_follows", "datatype": dbt_utils.type_int()},
    {"name": "viral_full_screen_plays", "datatype": dbt_utils.type_int()},
    {"name": "viral_impressions", "datatype": dbt_utils.type_int()},
    {"name": "viral_landing_page_clicks", "datatype": dbt_utils.type_int()},
    {"name": "viral_likes", "datatype": dbt_utils.type_int()},
    {"name": "viral_one_click_lead_form_opens", "datatype": dbt_utils.type_int()},
    {"name": "viral_one_click_leads", "datatype": dbt_utils.type_int()},
    {"name": "viral_other_engagements", "datatype": dbt_utils.type_int()},
    {"name": "viral_shares", "datatype": dbt_utils.type_int()},
    {"name": "viral_total_engagements", "datatype": dbt_utils.type_int()},
    {"name": "viral_video_completions", "datatype": dbt_utils.type_int()},
    {"name": "viral_video_first_quartile_completions", "datatype": dbt_utils.type_int()},
    {"name": "viral_video_midpoint_completions", "datatype": dbt_utils.type_int()},
    {"name": "viral_video_starts", "datatype": dbt_utils.type_int()},
    {"name": "viral_video_third_quartile_completions", "datatype": dbt_utils.type_int()},
    {"name": "viral_video_views", "datatype": dbt_utils.type_int()}
] %}

{{ return(columns) }}

{% endmacro %}



{% macro get_linkedin_ads_campaign_group_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "account_id", "datatype": dbt_utils.type_string()},
    {"name": "created_time", "datatype": dbt_utils.type_timestamp(), "alias": "created_at"},
    {"name": "id", "datatype": dbt_utils.type_string(), "alias": "campaign_group_id"},
    {"name": "last_modified_time", "datatype": dbt_utils.type_timestamp(), "alias": "last_modified_at"},
    {"name": "name", "datatype": dbt_utils.type_string(), "alias": "campaign_group_name"}
] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_linkedin_ads_campaign_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "account_id", "datatype": dbt_utils.type_string()},
    {"name": "campaign_group_id", "datatype": dbt_utils.type_string()},
    {"name": "cost_type", "datatype": dbt_utils.type_string()},
    {"name": "created_time", "datatype": dbt_utils.type_timestamp(), "alias": "created_at"},
    {"name": "id", "datatype": dbt_utils.type_string(), "alias": "campaign_id"},
    {"name": "last_modified_time", "datatype": dbt_utils.type_timestamp(), "alias": "last_modified_at"},
    {"name": "name", "datatype": dbt_utils.type_string(), "alias": "campaign_name"},
    {"name": "version_tag", "datatype": dbt_utils.type_int()}
] %}

{{ return(columns) }}

{% endmacro %}



{% macro get_linkedin_ads_creative_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "campaign_id", "datatype": dbt_utils.type_string()},
    {"name": "click_uri", "datatype": dbt_utils.type_string()},
    {"name": "created_time", "datatype": dbt_utils.type_timestamp(), "alias": "created_at"},
    {"name": "id", "datatype": dbt_utils.type_int(), "alias": "creative_id"},
    {"name": "last_modified_time", "datatype": dbt_utils.type_timestamp(), "alias": "last_modified_at"},
    {"name": "status", "datatype": dbt_utils.type_string(), "alias": "creative_status"},
    {"name": "type", "datatype": dbt_utils.type_string(), "alias": "creative_type"},
    {"name": "version_tag", "datatype": dbt_utils.type_int()}
] %}

{{ return(columns) }}

{% endmacro %}