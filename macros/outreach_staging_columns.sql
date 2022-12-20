{% macro get_staging_outreach_account_columns() %}

{% set columns = [
    {"name": "company_type", "datatype": dbt_utils.type_string()},
    {"name": "id", "datatype": dbt_utils.type_string(), "alias": "account_id"},
    {"name": "linked_in_url", "datatype": dbt_utils.type_string()},
    {"name": "locality", "datatype": dbt_utils.type_string()},
    {"name": "number_of_employees", "datatype": dbt_utils.type_numeric()},
    {"name": "type", "datatype": dbt_utils.type_string(), "alias": "account_type"},
    {"name": "description", "datatype": dbt_utils.type_string(), "alias": "account_description"},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "campaign_id", "datatype": dbt_utils.type_string()},
    {"name": "buyer_intent_score", "datatype": dbt_utils.type_numeric()},
    {"name": "founded_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "relationship", "datatype": dbt_utils.type_numeric()},
    {"name": "website_url", "datatype": dbt_utils.type_string()},
    {"name": "industry", "datatype": dbt_utils.type_string()},
    {"name": "relationship_owner_id", "datatype": dbt_utils.type_string(), "alias": "owner_id"},
    {"name": "sharing_id", "datatype": dbt_utils.type_string()},
    {"name": "domain", "datatype": dbt_utils.type_string()},
    {"name": "external_source", "datatype": dbt_utils.type_string()},
    {"name": "followers", "datatype": dbt_utils.type_numeric()},
    {"name": "natural_name", "datatype": dbt_utils.type_string()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()}

] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_staging_outreach_opportunity_columns() %}

{% set columns = [
    {"name": "id", "datatype": dbt_utils.type_string(), "alias": "opportunity_id"},
    {"name": "relationship_account_id", "datatype": dbt_utils.type_string(), "alias": "account_id"},
    {"name": "relationship_owner_id", "datatype": dbt_utils.type_string(), "alias": "owner_id"},
    {"name": "relationship_creator_id", "datatype": dbt_utils.type_string(), "alias": "creator_id"},
    {"name": "relationship_updater_id", "datatype": dbt_utils.type_string(), "alias": "updater_id"},
    {"name": "relationship_stage_id", "datatype": dbt_utils.type_string(), "alias": "stage_id"},
    {"name": "relationship_opportunity_stage_id", "datatype": dbt_utils.type_string(), "alias": "opportunity_stage_id"},
    {"name": "amount", "datatype": dbt_utils.type_numeric()},
    {"name": "close_date", "datatype": dbt_utils.type_timestamp()},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "description", "datatype": dbt_utils.type_string(), "alias": "opportunity_description"},
    {"name": "external_created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "map_link", "datatype": dbt_utils.type_string()},
    {"name": "map_next_steps", "datatype": dbt_utils.type_string()},
    {"name": "map_status", "datatype": dbt_utils.type_string()},
    {"name": "name", "datatype": dbt_utils.type_string(), "alias": "opportunity_name"},
    {"name": "next_step", "datatype": dbt_utils.type_string()},
    {"name": "opportunity_type", "datatype": dbt_utils.type_string()},
    {"name": "probability", "datatype": dbt_utils.type_numeric(), "alias": "opportunity_probability"},
    {"name": "prospecting_rep_id", "datatype": dbt_utils.type_string()},
    {"name": "sharing_team_id", "datatype": dbt_utils.type_string()},
    {"name": "touched_at", "datatype": dbt_utils.type_string(), "alias": "account_description"},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}