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


{% macro get_hubspot_company_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "id", "datatype": dbt_utils.type_int(), "alias": "company_id"},
    {"name": "is_deleted", "datatype": "boolean"},
    {"name": "property_name", "datatype": dbt_utils.type_string(), "alias": "company_name"},
    {"name": "property_description", "datatype": dbt_utils.type_string(), "alias": "description"},
    {"name": "property_createdate", "datatype": dbt_utils.type_timestamp(), "alias": "created_at"},
    {"name": "property_address", "datatype": dbt_utils.type_string(), "alias": "address"},
    {"name": "property_address_2", "datatype": dbt_utils.type_string(), "alias": "address_2"},
    {"name": "property_city", "datatype": dbt_utils.type_string(), "alias": "city"},
    {"name": "property_state", "datatype": dbt_utils.type_string(), "alias": "state"},
    {"name": "property_country", "datatype": dbt_utils.type_string(), "alias": "country"},
    {"name": "property_annualrevenue", "datatype": dbt_utils.type_int(), "alias": "company_annual_revenue"},
    {"name": "property_hs_analytics_source", "datatype": dbt_utils.type_string(), "alias": "analytics_source"},
    {"name": "property_recent_conversion_date", "datatype": dbt_utils.type_string(), "alias": "recent_conversion_date"},
    {"name": "property_first_conversion_date", "datatype": dbt_utils.type_string(), "alias": "first_conversion_date"},
    {"name": "property_industry", "datatype": dbt_utils.type_string(), "alias": "industry"},
    {"name": "property_first_contact_createdate", "datatype": dbt_utils.type_string(), "alias": "first_contact_create_date"},
    {"name": "property_notes_last_contacted", "datatype": dbt_utils.type_string(), "alias": "notes_last_contacted"},
    {"name": "property_num_associated_deals", "datatype": dbt_utils.type_string(), "alias": "num_associated_deals"},
    {"name": "property_hs_total_deal_value", "datatype": dbt_utils.type_string(), "alias": "total_deal_value"},
    {"name": "property_first_deal_created_date", "datatype": dbt_utils.type_string(), "alias": "first_deal_created_date"},
    {"name": "property_lifecyclestage", "datatype": dbt_utils.type_string(), "alias": "lifecycle_stage"},
    {"name": "property_hubspot_owner_assigneddate", "datatype": dbt_utils.type_string(), "alias": "owner_assigned_date"},
    {"name": "property_relationship_type", "datatype": dbt_utils.type_string(), "alias": "relationship_type"},
    {"name": "property_closedate", "datatype": dbt_utils.type_string(), "alias": "close_date"},
    {"name": "property_total_revenue", "datatype": dbt_utils.type_string(), "alias": "total_revenue"},
    {"name": "property_days_to_close", "datatype": dbt_utils.type_string(), "alias": "days_to_close"},
    {"name": "property_hs_lead_status", "datatype": dbt_utils.type_string(), "alias": "lead_status"},
    {"name": "property_hs_time_in_marketingqualifiedlead", "datatype": dbt_utils.type_string(), "alias": "time_in_marketingqualifiedlead"},
    {"name": "property_hs_time_in_lead", "datatype": dbt_utils.type_string(), "alias": "time_in_lead"},
    {"name": "property_hs_time_in_customer", "datatype": dbt_utils.type_string(), "alias": "time_in_customer"},
    {"name": "property_hs_time_in_subscriber", "datatype": dbt_utils.type_string(), "alias": "time_in_subscriber"},
    {"name": "property_hs_time_in_salesqualifiedlead", "datatype": dbt_utils.type_string(), "alias": "time_in_salesqualifiedlead"},
    {"name": "property_hs_time_in_evangelist", "datatype": dbt_utils.type_string(), "alias": "time_in_evangelist"},
    {"name": "property_hs_time_in_opportunity", "datatype": dbt_utils.type_string(), "alias": "time_in_opportunity"}
    
] %}

{{ fivetran_utils.add_pass_through_columns(columns, var('hubspot__company_pass_through_columns')) }}

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
    {"name": "date_entered", "datatype": dbt_utils.type_timestamp(), "alias": "deal_stage_entered"},
    {"name": "deal_id", "datatype": dbt_utils.type_int()},
    {"name": "source", "datatype": dbt_utils.type_string()},
    {"name": "source_id", "datatype": dbt_utils.type_string()},
    {"name": "value", "datatype": dbt_utils.type_string(), "alias": "deal_stage_name"}
] %}


{{ return(columns) }}

{% endmacro %}
