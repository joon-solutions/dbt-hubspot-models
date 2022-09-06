{% macro get_google_analytics_ga_adwords_campaigns_columns() %}

{% set columns = [

        {"name": "date", "datatype": dbt_utils.type_timestamp()},
        {"name": "adwords_campaign_id", "datatype": dbt_utils.type_string()},
        {"name": "_fivetran_id", "datatype": dbt_utils.type_string()},
        {"name": "ad_clicks", "datatype": dbt_utils.type_int()},
        {"name": "ad_cost", "datatype": dbt_utils.type_float()},
        {"name": "cpc", "datatype": dbt_utils.type_float()},
        {"name": "users", "datatype": dbt_utils.type_int()},
        {"name": "sessions", "datatype": dbt_utils.type_int()},
        {"name": "bounce_rate", "datatype": dbt_utils.type_float()},
        {"name": "goal_conversion_rate_all", "datatype": dbt_utils.type_float()},
        {"name": "goal_completions_all", "datatype": dbt_utils.type_int()},
        {"name": "goal_value_all", "datatype": dbt_utils.type_float()},
        {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_google_analytics_ga_adwords_hourly_stats_columns() %}

{% set columns = [

        {"name": "date", "datatype": dbt_utils.type_timestamp()},
        {"name": "datehour", "datatype": dbt_utils.type_string()},
        {"name": "_fivetran_id", "datatype": dbt_utils.type_string()},
        {"name": "ad_clicks", "datatype": dbt_utils.type_int()},
        {"name": "ad_cost", "datatype": dbt_utils.type_float()},
        {"name": "cpc", "datatype": dbt_utils.type_float()},
        {"name": "users", "datatype": dbt_utils.type_int()},
        {"name": "sessions", "datatype": dbt_utils.type_int()},
        {"name": "bounce_rate", "datatype": dbt_utils.type_float()},
        {"name": "page_views_per_session", "datatype": dbt_utils.type_float()},
        {"name": "goal_conversion_rate_all", "datatype": dbt_utils.type_float()},
        {"name": "goal_completions_all", "datatype": dbt_utils.type_int()},
        {"name": "goal_value_all", "datatype": dbt_utils.type_float()},
        {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()}

] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_google_analytics_ga_adwords_keyword_columns() %}

{% set columns = [

        {"name": "date", "datatype": dbt_utils.type_timestamp()},
        {"name": "keyword", "datatype": dbt_utils.type_string()},
        {"name": "_fivetran_id", "datatype": dbt_utils.type_string()},
        {"name": "ad_clicks", "datatype": dbt_utils.type_int()},
        {"name": "ad_cost", "datatype": dbt_utils.type_float()},
        {"name": "cpc", "datatype": dbt_utils.type_float()},
        {"name": "users", "datatype": dbt_utils.type_int()},
        {"name": "sessions", "datatype": dbt_utils.type_int()},
        {"name": "bounce_rate", "datatype": dbt_utils.type_float()},
        {"name": "page_views_per_session", "datatype": dbt_utils.type_float()},
        {"name": "goal_conversion_rate_all", "datatype": dbt_utils.type_float()},
        {"name": "goal_completions_all", "datatype": dbt_utils.type_int()},
        {"name": "goal_value_all", "datatype": dbt_utils.type_float()},
        {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()}

] %}

{{ return(columns) }}

{% endmacro %}



{% macro get_google_analytics_ga_audience_overview_columns() %}

{% set columns = [

        {"name": "date", "datatype": dbt_utils.type_timestamp()},
        {"name": "_fivetran_id", "datatype": dbt_utils.type_string()},
        {"name": "users", "datatype": dbt_utils.type_int()},
        {"name": "new_users", "datatype": dbt_utils.type_int()},
        {"name": "sessions", "datatype": dbt_utils.type_int()},
        {"name": "sessions_per_user", "datatype": dbt_utils.type_float()},
        {"name": "page_views", "datatype": dbt_utils.type_int()},
        {"name": "page_views_per_session", "datatype": dbt_utils.type_float()},
        {"name": "avg_session_duration", "datatype": dbt_utils.type_float()},
        {"name": "bounce_rate", "datatype": dbt_utils.type_float()},
        {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()}

] %}

{{ return(columns) }}

{% endmacro %}



{% macro get_google_analytics_ga_browser_and_operating_system_overview_columns() %}

{% set columns = [

        {"name": "date", "datatype": dbt_utils.type_timestamp()},
        {"name": "_fivetran_id", "datatype": dbt_utils.type_string()},
        {"name": "operating_system", "datatype": dbt_utils.type_string()},
        {"name": "browser", "datatype": dbt_utils.type_string()},
        {"name": "users", "datatype": dbt_utils.type_int()},
        {"name": "new_users", "datatype": dbt_utils.type_int()},
        {"name": "sessions", "datatype": dbt_utils.type_int()},
        {"name": "bounce_rate", "datatype": dbt_utils.type_float()},
        {"name": "page_views_per_session", "datatype": dbt_utils.type_float()},
        {"name": "avg_session_duration", "datatype": dbt_utils.type_float()},
        {"name": "goal_conversion_rate_all", "datatype": dbt_utils.type_float()},
        {"name": "goal_completions_all", "datatype": dbt_utils.type_int()},
        {"name": "goal_value_all", "datatype": dbt_utils.type_float()},
        {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()}

] %}

{{ return(columns) }}

{% endmacro %}



{% macro get_google_analytics_ga_campaign_performance_columns() %}

{% set columns = [

{"name": "date", "datatype": dbt_utils.type_timestamp()},
{"name": "campaign", "datatype": dbt_utils.type_string()},
{"name": "_fivetran_id", "datatype": dbt_utils.type_string()},
{"name": "users", "datatype": dbt_utils.type_int()},
{"name": "new_users", "datatype": dbt_utils.type_int()},
{"name": "sessions", "datatype": dbt_utils.type_int()},
{"name": "bounce_rate", "datatype": dbt_utils.type_float()},
{"name": "page_views_per_session", "datatype": dbt_utils.type_float()},
{"name": "goal_conversion_rate_all", "datatype": dbt_utils.type_float()},
{"name": "goal_completions_all", "datatype": dbt_utils.type_int()},
{"name": "goal_value_all", "datatype": dbt_utils.type_float()},
{"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()}

] %}

{{ return(columns) }}

{% endmacro %}




{% macro get_google_analytics_ga_channel_traffic_columns() %}

{% set columns = [

        {"name": "date", "datatype": dbt_utils.type_timestamp()},
        {"name": "profile", "datatype": dbt_utils.type_string()},
        {"name": "_fivetran_id", "datatype": dbt_utils.type_string()},
        {"name": "channel_grouping", "datatype": dbt_utils.type_string()},
        {"name": "goal_value_all", "datatype": dbt_utils.type_float()},
        {"name": "new_users", "datatype": dbt_utils.type_int()},
        {"name": "sessions", "datatype": dbt_utils.type_int()},
        {"name": "avg_session_duration", "datatype": dbt_utils.type_float()},
        {"name": "goal_completions_all", "datatype": dbt_utils.type_int()},
        {"name": "page_views_per_session", "datatype": dbt_utils.type_float()},
        {"name": "goal_conversion_rate_all", "datatype": dbt_utils.type_float()},
        {"name": "users", "datatype": dbt_utils.type_int()},
        {"name": "bounce_rate", "datatype": dbt_utils.type_float()},
        {"name": "percent_new_sessions", "datatype": dbt_utils.type_float()},
        {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()}

] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_google_analytics_ga_events_overview_columns() %}

{% set columns = [

        {"name": "date", "datatype": dbt_utils.type_timestamp()},
        {"name": "profile", "datatype": dbt_utils.type_string()},
        {"name": "_fivetran_id", "datatype": dbt_utils.type_string()},
        {"name": "event_category", "datatype": dbt_utils.type_string()},
        {"name": "event_value", "datatype": dbt_utils.type_int()},
        {"name": "total_events", "datatype": dbt_utils.type_int()},
        {"name": "sessions_with_event", "datatype": dbt_utils.type_int()},
        {"name": "events_per_session_with_event", "datatype": dbt_utils.type_float()},
        {"name": "avg_event_value", "datatype": dbt_utils.type_float()},
        {"name": "unique_events", "datatype": dbt_utils.type_int()},
        {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()}

] %}

{{ return(columns) }}

{% endmacro %}



{% macro get_google_analytics_ga_social_media_acquisitions_columns() %}

{% set columns = [

         {"name": "date", "datatype": dbt_utils.type_timestamp()},
         {"name": "social_network", "datatype": dbt_utils.type_string()},
         {"name": "_fivetran_id", "datatype": dbt_utils.type_string()},
         {"name": "sessions", "datatype": dbt_utils.type_int()},
         {"name": "percent_new_sessions", "datatype": dbt_utils.type_float()},
         {"name": "new_users", "datatype": dbt_utils.type_int()},
         {"name": "bounce_rate", "datatype": dbt_utils.type_float()},
         {"name": "page_views", "datatype": dbt_utils.type_int()},
         {"name": "page_views_per_session", "datatype": dbt_utils.type_float()},
         {"name": "avg_session_duration", "datatype": dbt_utils.type_int()},
         {"name": "transactions_per_session", "datatype": dbt_utils.type_float()},
         {"name": "transaction_revenue", "datatype": dbt_utils.type_int()},
         {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}



{% macro get_google_analytics_ga_traffic_columns() %}

{% set columns = [

         {"name": "date", "datatype": dbt_utils.type_timestamp()},
         {"name": "page_title", "datatype": dbt_utils.type_string()},
         {"name": "_fivetran_id", "datatype": dbt_utils.type_string()},
         {"name": "users", "datatype": dbt_utils.type_int()},
         {"name": "page_value", "datatype": dbt_utils.type_int()},
         {"name": "entrances", "datatype": dbt_utils.type_float()},
         {"name": "page_views", "datatype": dbt_utils.type_int()},
         {"name": "unique_page_views", "datatype": dbt_utils.type_int()},
         {"name": "avg_time_on_page", "datatype": dbt_utils.type_int()},
         {"name": "percent_exit", "datatype": dbt_utils.type_float()},
         {"name": "bounce_rate", "datatype": dbt_utils.type_float()},
         {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()}

] %}

{{ return(columns) }}

{% endmacro %}