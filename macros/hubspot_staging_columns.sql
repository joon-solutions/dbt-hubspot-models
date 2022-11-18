{% macro get_hubspot_contact_form_submission_columns() %}

{% set columns = [

    {"name": "contact_id", "datatype": dbt_utils.type_int()},
    {"name": "conversion_id", "datatype": dbt_utils.type_string()},
    {"name": "form_id", "datatype": dbt_utils.type_string()},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}



{% macro get_hubspot_contact_list_member_columns() %}

{% set columns = [

        {"name": "contact_id", "datatype": dbt_utils.type_int()},
        {"name": "contact_list_id", "datatype": dbt_utils.type_int()},
        {"name": "_fivetran_deleted", "datatype": "boolean"},
        {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}



{% macro get_hubspot_contact_list_columns() %}

{% set columns = [

         {"name": "id", "datatype": dbt_utils.type_int(), "alias": "contact_list_id"},
         {"name": "name", "datatype": dbt_utils.type_string(), "alias": "contact_list_name"},
         {"name": "_fivetran_deleted", "datatype": "boolean"},
         {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()}

] %}

{{ return(columns) }}

{% endmacro %}




{% macro get_hubspot_contact_columns() %}

{% set columns = [

        {"name": "id", "datatype": dbt_utils.type_int(), "alias": "contact_id"},
        {"name": "_fivetran_deleted", "datatype": "boolean"},
        {"name": "property_name", "datatype": dbt_utils.type_string(), "alias": "contact_name"},
        {"name": "property_email", "datatype": dbt_utils.type_string(), "alias": "contact_email"},
        {"name": "property_address", "datatype": dbt_utils.type_string(), "alias": "contact_address"},
        {"name": "property_city", "datatype": dbt_utils.type_string(), "alias": "contact_city"},
        {"name": "property_hs_analytics_source", "datatype": dbt_utils.type_string(), "alias": "analytics_source"},
        {"name": "property_country", "datatype": dbt_utils.type_string(), "alias": "contact_country"},
        {"name": "property_jobtitle", "datatype": dbt_utils.type_string(), "alias": "contact_job_title"},
        {"name": "property_company", "datatype": dbt_utils.type_string(), "alias": "contact_company"},
        {"name": "property_createdate", "datatype": dbt_utils.type_timestamp(), "alias": "created_at"},
        {"name": "property_phone", "datatype": dbt_utils.type_string()},
        {"name": "property_mobilephone", "datatype": dbt_utils.type_string()}
        
] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_hubspot_email_campaign_columns() %}

{% set columns = [

         {"name": "id", "datatype": dbt_utils.type_int(), "alias": "email_campaign_id"},
         {"name": "name", "datatype": dbt_utils.type_string(), "alias": "email_campaign_name"},
         {"name": "type", "datatype": dbt_utils.type_string(), "alias": "email_campaign_type"},
         {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_hubspot_email_event_columns() %}

{% set columns = [

        {"name": "id", "datatype": dbt_utils.type_string(), "alias": "email_event_id"},
        {"name": "created", "datatype": dbt_utils.type_timestamp(), "alias": "created_at"},
        {"name": "type", "datatype": dbt_utils.type_string(), "alias": "event_type"},
        {"name": "recipient", "datatype": dbt_utils.type_string()},
        {"name": "email_campaign_id", "datatype": dbt_utils.type_int()},
        {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_hubspot_email_subscription_change_columns() %}

{% set columns = [

        {"name": "recipient", "datatype": dbt_utils.type_string()},
        {"name": "timestamp", "datatype": dbt_utils.type_string(), "alias": "created_at"},
        {"name": "change", "datatype": dbt_utils.type_string()},
        {"name": "caused_by_event_id", "datatype": dbt_utils.type_string()}, 
        {"name": "email_subscription_id", "datatype": dbt_utils.type_string()},
        {"name": "_fivetran_id", "datatype": dbt_utils.type_string(), "alias": "id"},
        {"name": "_fivetran_synced", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}



{% macro get_hubspot_engagement_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "active", "datatype": "boolean", "alias": "is_active"},
    {"name": "activity_type", "datatype": dbt_utils.type_string()},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp(), "alias": "created_timestamp"},
    {"name": "id", "datatype": dbt_utils.type_int(), "alias": "engagement_id"},
    {"name": "last_updated", "datatype": dbt_utils.type_timestamp(), "alias": "last_updated_timestamp"},
    {"name": "owner_id", "datatype": dbt_utils.type_int()},
    {"name": "portal_id", "datatype": dbt_utils.type_int()},
    {"name": "timestamp", "datatype": dbt_utils.type_timestamp(), "alias": "occurred_timestamp"},
    {"name": "type", "datatype": dbt_utils.type_string(), "alias": "engagement_type"}
] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_hubspot_engagement_contact_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "contact_id", "datatype": dbt_utils.type_int()},
    {"name": "engagement_id", "datatype": dbt_utils.type_int()}
] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_hubspot_engagement_deal_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "deal_id", "datatype": dbt_utils.type_int()},
    {"name": "engagement_id", "datatype": dbt_utils.type_int()}
] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_hubspot_engagement_company_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "company_id", "datatype": dbt_utils.type_int()},
    {"name": "engagement_id", "datatype": dbt_utils.type_int()}
] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_hubspot_deal_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "deal_id", "datatype": dbt_utils.type_int()},
    {"name": "deal_pipeline_id", "datatype": dbt_utils.type_string()},
    {"name": "deal_pipeline_stage_id", "datatype": dbt_utils.type_string()},
    {"name": "is_deleted", "datatype": "boolean"},
    {"name": "owner_id", "datatype": dbt_utils.type_int()},
    {"name": "portal_id", "datatype": dbt_utils.type_int()},
    {"name": "property_dealname", "datatype": dbt_utils.type_string(), "alias": "deal_name"},
    {"name": "property_description", "datatype": dbt_utils.type_string()},
    {"name": "property_amount", "datatype": dbt_utils.type_int()},
    {"name": "property_closedate", "datatype": dbt_utils.type_timestamp(), "alias": "closed_at"},
    {"name": "property_createdate", "datatype": dbt_utils.type_timestamp(), "alias": "created_at"}
] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_hubspot_deal_pipeline_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "active", "datatype": "boolean", "alias": "is_pipeline_active"},
    {"name": "display_order", "datatype": dbt_utils.type_int(), "alias":"pipeline_display_order"},
    {"name": "label", "datatype": dbt_utils.type_string(), "alias": "pipeline_label"},
    {"name": "pipeline_id", "datatype": dbt_utils.type_string(), "alias": "deal_pipeline_id"}
] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_hubspot_deal_pipeline_stage_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "active", "datatype": "boolean", "alias": "is_pipeline_stage_active"},
    {"name": "closed_won", "datatype": "boolean", "alias": "is_pipeline_stage_closed_won"},
    {"name": "display_order", "datatype": dbt_utils.type_int(),"alias":"pipeline_stage_display_order"},
    {"name": "label", "datatype": dbt_utils.type_string(), "alias": "pipeline_stage_label"},
    {"name": "pipeline_id", "datatype": dbt_utils.type_string(), "alias": "deal_pipeline_id"},
    {"name": "probability", "datatype": dbt_utils.type_float(), "alias":"pipeline_stage_probability"},
    {"name": "stage_id", "datatype": dbt_utils.type_string(), "alias": "deal_pipeline_stage_id"}
] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_hubspot_owner_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "email", "datatype": dbt_utils.type_string(), "alias": "email_address"},
    {"name": "first_name", "datatype": dbt_utils.type_string()},
    {"name": "last_name", "datatype": dbt_utils.type_string()},
    {"name": "owner_id", "datatype": dbt_utils.type_int()},
    {"name": "portal_id", "datatype": dbt_utils.type_int()},
    {"name": "type", "datatype": dbt_utils.type_string(), "alias": "owner_type"},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_hubspot_deal_stage_columns() %}

{% set columns = [
    {"name": "_fivetran_active", "datatype": "boolean"},
    {"name": "_fivetran_end", "datatype": dbt_utils.type_timestamp()},
    {"name": "_fivetran_start", "datatype": dbt_utils.type_timestamp()},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "date_entered", "datatype": dbt_utils.type_timestamp()},
    {"name": "deal_id", "datatype": dbt_utils.type_int()},
    {"name": "source", "datatype": dbt_utils.type_string()},
    {"name": "source_id", "datatype": dbt_utils.type_string()},
    {"name": "value", "datatype": dbt_utils.type_string(), "alias": "deal_stage_name"}
] %}


{{ return(columns) }}

{% endmacro %}
