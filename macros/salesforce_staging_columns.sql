{% macro get_salesforce_account_columns() %}

{% set columns = [

    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "account_number", "datatype": dbt_utils.type_string()},
    {"name": "account_source", "datatype": dbt_utils.type_string()},
    {"name": "annual_revenue", "datatype": dbt_utils.type_float()},
    {"name": "billing_city", "datatype": dbt_utils.type_string()},
    {"name": "billing_country", "datatype": dbt_utils.type_string()},
    {"name": "billing_postal_code", "datatype": dbt_utils.type_string()},
    {"name": "billing_state", "datatype": dbt_utils.type_string()},
    {"name": "billing_state_code", "datatype": dbt_utils.type_string()},
    {"name": "billing_street", "datatype": dbt_utils.type_string()},
    {"name": "description", "datatype": dbt_utils.type_string(), "alias": "account_description"},
    {"name": "id", "datatype": dbt_utils.type_string(), "alias": "account_id"},
    {"name": "industry", "datatype": dbt_utils.type_string()},
    {"name": "is_deleted", "datatype": "boolean"},
    {"name": "last_activity_date", "datatype": dbt_utils.type_timestamp()},
    {"name": "last_referenced_date", "datatype": dbt_utils.type_timestamp()},
    {"name": "last_viewed_date", "datatype": dbt_utils.type_timestamp()},
    {"name": "master_record_id", "datatype": dbt_utils.type_string()},
    {"name": "name", "datatype": dbt_utils.type_string(), "alias": "account_name"},
    {"name": "number_of_employees", "datatype": dbt_utils.type_int()},
    {"name": "owner_id", "datatype": dbt_utils.type_string()},
    {"name": "ownership", "datatype": dbt_utils.type_string()},
    {"name": "parent_id", "datatype": dbt_utils.type_string()},
    {"name": "rating", "datatype": dbt_utils.type_string()},
    {"name": "record_type_id", "datatype": dbt_utils.type_string()},
    {"name": "shipping_city", "datatype": dbt_utils.type_string()},
    {"name": "shipping_country", "datatype": dbt_utils.type_string()},
    {"name": "shipping_country_code", "datatype": dbt_utils.type_string()},
    {"name": "shipping_postal_code", "datatype": dbt_utils.type_string()},
    {"name": "shipping_state", "datatype": dbt_utils.type_string()},
    {"name": "shipping_state_code", "datatype": dbt_utils.type_string()},
    {"name": "shipping_street", "datatype": dbt_utils.type_string()},
    {"name": "type", "datatype": dbt_utils.type_string(), "alias": "account_type"},
    {"name": "website", "datatype": dbt_utils.type_string()},
] %}

{{ return(columns) }}

{% endmacro %}



{% macro get_salesforce_opportunity_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "PRICEBOOK_2_ID", "datatype": dbt_utils.type_string()},
    {"name": "account_id", "datatype": dbt_utils.type_string()},
    {"name": "amount", "datatype": dbt_utils.type_float()},
    {"name": "campaign_id", "datatype": dbt_utils.type_string()},
    {"name": "close_date", "datatype": dbt_utils.type_timestamp()},
    {"name": "created_date", "datatype": dbt_utils.type_timestamp()},
    {"name": "description", "datatype": dbt_utils.type_string(), "alias": "opportunity_description"},
    {"name": "expected_revenue", "datatype": dbt_utils.type_numeric()},
    {"name": "fiscal", "datatype": dbt_utils.type_string()},
    {"name": "fiscal_quarter", "datatype": dbt_utils.type_int()},
    {"name": "fiscal_year", "datatype": dbt_utils.type_int()},
    {"name": "forecast_category", "datatype": dbt_utils.type_string()},
    {"name": "forecast_category_name", "datatype": dbt_utils.type_string()},
    {"name": "has_open_activity", "datatype": "boolean"},
    {"name": "has_opportunity_line_item", "datatype": "boolean"},
    {"name": "has_overdue_task", "datatype": "boolean"},
    {"name": "id", "datatype": dbt_utils.type_string(), "alias": "opportunity_id"},
    {"name": "is_closed", "datatype": "boolean"},
    {"name": "is_deleted", "datatype": "boolean"},
    {"name": "is_won", "datatype": "boolean"},
    {"name": "last_activity_date", "datatype": dbt_utils.type_timestamp()},
    {"name": "last_referenced_date", "datatype": dbt_utils.type_timestamp()},
    {"name": "last_viewed_date", "datatype": dbt_utils.type_timestamp()},
    {"name": "lead_source", "datatype": dbt_utils.type_string()},
    {"name": "name", "datatype": dbt_utils.type_string(), "alias": "opportunity_name"},
    {"name": "next_step", "datatype": dbt_utils.type_string()},
    {"name": "owner_id", "datatype": dbt_utils.type_string()},
    {"name": "probability", "datatype": dbt_utils.type_float(), "alias": "opportunity_probability"},
    {"name": "record_type_id", "datatype": dbt_utils.type_string()},
    {"name": "stage_name", "datatype": dbt_utils.type_string()},
    {"name": "synced_quote_id", "datatype": dbt_utils.type_string()},
    {"name": "type", "datatype": dbt_utils.type_string(), "alias": "opportunity_type"},
] %}

{{ return(columns) }}

{% endmacro %}



{% macro get_salesforce_user_role_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "developer_name", "datatype": dbt_utils.type_string()},
    {"name": "id", "datatype": dbt_utils.type_string(),  "alias": "user_role_id"},
    {"name": "name", "datatype": dbt_utils.type_string(),  "alias": "user_role_name"},
    {"name": "opportunity_access_for_account_owner", "datatype": dbt_utils.type_string()},
    {"name": "parent_role_id", "datatype": dbt_utils.type_string()},
    {"name": "rollup_description", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}




{% macro get_salesforce_user_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "account_id", "datatype": dbt_utils.type_string()},
    {"name": "alias", "datatype": dbt_utils.type_string()},
    {"name": "city", "datatype": dbt_utils.type_string()},
    {"name": "company_name", "datatype": dbt_utils.type_string()},
    {"name": "contact_id", "datatype": dbt_utils.type_string()},
    {"name": "country", "datatype": dbt_utils.type_string()},
    {"name": "country_code", "datatype": dbt_utils.type_string()},
    {"name": "department", "datatype": dbt_utils.type_string()},
    {"name": "email", "datatype": dbt_utils.type_string()},
    {"name": "first_name", "datatype": dbt_utils.type_string()},
    {"name": "id", "datatype": dbt_utils.type_string(), "alias": "user_id"},
    {"name": "individual_id", "datatype": dbt_utils.type_string()},
    {"name": "is_active", "datatype": "boolean"},
    {"name": "last_login_date", "datatype": dbt_utils.type_timestamp()},
    {"name": "last_name", "datatype": dbt_utils.type_string()},
    {"name": "last_referenced_date", "datatype": dbt_utils.type_timestamp()},
    {"name": "last_viewed_date", "datatype": dbt_utils.type_timestamp()},
    {"name": "manager_id", "datatype": dbt_utils.type_string()},
    {"name": "name", "datatype": dbt_utils.type_string(), "alias": "user_name"},
    {"name": "postal_code", "datatype": dbt_utils.type_string()},
    {"name": "profile_id", "datatype": dbt_utils.type_string()},
    {"name": "state", "datatype": dbt_utils.type_string()},
    {"name": "state_code", "datatype": dbt_utils.type_string()},
    {"name": "street", "datatype": dbt_utils.type_string()},
    {"name": "title", "datatype": dbt_utils.type_string()},
    {"name": "user_role_id", "datatype": dbt_utils.type_string()},
    {"name": "user_type", "datatype": dbt_utils.type_string()},
    {"name": "username", "datatype": dbt_utils.type_string()},
] %}


{{ return(columns) }}

{% endmacro %}

