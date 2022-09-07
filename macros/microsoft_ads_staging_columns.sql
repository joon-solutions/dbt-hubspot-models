{% macro get_microsoft_ads_account_history_columns() %}

{% set columns = [
        
        {"name": "id", "datatype": dbt_utils.type_string(), "alias": "account_id"},
        {"name": "name", "datatype": dbt_utils.type_string(), "alias": "account_name"},
        {"name": "last_modified_time", "datatype": dbt_utils.type_timestamp(), "alias": "modified_timestamp"} 
] %}

{{ return(columns) }}

{% endmacro %}



{% macro get_microsoft_ads_ad_group_history_columns() %}

{% set columns = [

        {"name": "id", "datatype": dbt_utils.type_string(), "alias": "ad_group_id"},
        {"name": "campaign_id", "datatype": dbt_utils.type_string()},
        {"name": "name", "datatype": dbt_utils.type_string(), "alias": "ad_group_name"},
        {"name": "modified_time", "datatype": dbt_utils.type_timestamp(), "alias": "modified_timestamp"}

] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_microsoft_ads_ad_history_columns() %}

{% set columns = [

        {"name": "id", "datatype": dbt_utils.type_string(), "alias": "ad_id"},
        {"name": "final_url", "datatype": dbt_utils.type_string()},
        {"name": "ad_group_id", "datatype": dbt_utils.type_string()},
        {"name": "modified_time", "datatype": dbt_utils.type_timestamp(), "alias": "modified_timestamp"}

] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_microsoft_ads_ad_performance_daily_report_columns() %}

{% set columns = [

        {"name": "date", "datatype": dbt_utils.type_timestamp(), "alias": "date_day"},
        {"name": "account_id", "datatype": dbt_utils.type_string()},
        {"name": "campaign_id", "datatype": dbt_utils.type_string()},
        {"name": "ad_group_id", "datatype": dbt_utils.type_string()},
        {"name": "ad_id", "datatype": dbt_utils.type_string()},
        {"name": "currency_code", "datatype": dbt_utils.type_string()},
        {"name": "ad_distribution", "datatype": dbt_utils.type_string()},
        {"name": "device_type", "datatype": dbt_utils.type_string()},
        {"name": "language", "datatype": dbt_utils.type_string()},
        {"name": "network", "datatype": dbt_utils.type_string()},
        {"name": "device_os", "datatype": dbt_utils.type_string()},
        {"name": "top_vs_other", "datatype": dbt_utils.type_string()},
        {"name": "bid_match_type", "datatype": dbt_utils.type_string()},
        {"name": "delivered_match_type", "datatype": dbt_utils.type_string()},
        {"name": "clicks", "datatype": dbt_utils.type_int()},
        {"name": "impressions", "datatype": dbt_utils.type_int()},
        {"name": "spend", "datatype": dbt_utils.type_float()}

] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_microsoft_ads_campaign_history_columns() %}

{% set columns = [

        {"name": "id", "datatype": dbt_utils.type_string(), "alias": "campaign_id"},
        {"name": "account_id", "datatype": dbt_utils.type_string()},
        {"name": "name", "datatype": dbt_utils.type_string(), "alias": "campaign_name"},
        {"name": "modified_time", "datatype": dbt_utils.type_timestamp(), "alias": "modified_timestamp"}

] %}

{{ return(columns) }}

{% endmacro %}
