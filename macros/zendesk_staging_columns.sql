{% macro get_zendesk_ticket_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "allow_channelback", "datatype": "boolean"},
    {"name": "assignee_id", "datatype": dbt_utils.type_int()},
    {"name": "brand_id", "datatype": dbt_utils.type_int()},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "description", "datatype": dbt_utils.type_string()},
    {"name": "due_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "external_id", "datatype": dbt_utils.type_int()},
    {"name": "forum_topic_id", "datatype": dbt_utils.type_int()},
    {"name": "group_id", "datatype": dbt_utils.type_int()},
    {"name": "has_incidents", "datatype": "boolean"},
    {"name": "id", "datatype": dbt_utils.type_int(), "alias": "ticket_id"},
    {"name": "is_public", "datatype": "boolean"},
    {"name": "merged_ticket_ids", "datatype": dbt_utils.type_string()},
    {"name": "organization_id", "datatype": dbt_utils.type_int()},
    {"name": "priority", "datatype": dbt_utils.type_string()},
    {"name": "problem_id", "datatype": dbt_utils.type_int()},
    {"name": "recipient", "datatype": dbt_utils.type_int()},
    {"name": "requester_id", "datatype": dbt_utils.type_int()},
    {"name": "status", "datatype": dbt_utils.type_string()},
    {"name": "subject", "datatype": dbt_utils.type_string()},
    {"name": "submitter_id", "datatype": dbt_utils.type_int()},
    {"name": "system_ccs", "datatype": dbt_utils.type_int()},
    {"name": "system_client", "datatype": dbt_utils.type_string()},
    {"name": "system_ip_address", "datatype": dbt_utils.type_string()},
    {"name": "system_json_email_identifier", "datatype": dbt_utils.type_int()},
    {"name": "system_latitude", "datatype": dbt_utils.type_float()},
    {"name": "system_location", "datatype": dbt_utils.type_string()},
    {"name": "system_longitude", "datatype": dbt_utils.type_float()},
    {"name": "system_machine_generated", "datatype": dbt_utils.type_int()},
    {"name": "system_message_id", "datatype": dbt_utils.type_int()},
    {"name": "system_raw_email_identifier", "datatype": dbt_utils.type_int()},
    {"name": "ticket_form_id", "datatype": dbt_utils.type_int()},
    {"name": "type", "datatype": dbt_utils.type_string()},
    {"name": "updated_at", "datatype": dbt_utils.type_string()},
    {"name": "url", "datatype": dbt_utils.type_string()},
    {"name": "via_channel", "datatype": dbt_utils.type_string(), "alias": "created_channel"},
    {"name": "via_source_from_address", "datatype": dbt_utils.type_int(), "alias": "source_from_address"},
    {"name": "via_source_from_id", "datatype": dbt_utils.type_int(), "alias": "source_from_id"},
    {"name": "via_source_from_title", "datatype": dbt_utils.type_int(), "alias": "source_from_title"},
    {"name": "via_source_rel", "datatype": dbt_utils.type_int(), "alias": "source_rel"},
    {"name": "via_source_to_address", "datatype": dbt_utils.type_int(), "alias": "source_to_address"},
    {"name": "via_source_to_name", "datatype": dbt_utils.type_int(), "alias": "source_to_name"}
] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_zendesk_ticket_tag_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "ticket_id", "datatype": dbt_utils.type_int()},
    {"name": "TAG", "datatype": dbt_utils.type_string(), "quote": True, "alias": "tags" }
] %}

{{ return(columns) }}

{% endmacro %}



{% macro get_zendesk_brand_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "active", "datatype": "boolean", "alias": "is_active"},
    {"name": "brand_url", "datatype": dbt_utils.type_string()},
    {"name": "has_help_center", "datatype": "boolean"},
    {"name": "help_center_state", "datatype": dbt_utils.type_string()},
    {"name": "id", "datatype": dbt_utils.type_int(), 'alias': "brand_id"},
    {"name": "logo_content_type", "datatype": dbt_utils.type_string()},
    {"name": "logo_content_url", "datatype": dbt_utils.type_string()},
    {"name": "logo_deleted", "datatype": "boolean"},
    {"name": "logo_file_name", "datatype": dbt_utils.type_string()},
    {"name": "logo_height", "datatype": dbt_utils.type_int()},
    {"name": "logo_id", "datatype": dbt_utils.type_int()},
    {"name": "logo_inline", "datatype": "boolean"},
    {"name": "logo_mapped_content_url", "datatype": dbt_utils.type_string()},
    {"name": "logo_size", "datatype": dbt_utils.type_int()},
    {"name": "logo_url", "datatype": dbt_utils.type_string()},
    {"name": "logo_width", "datatype": dbt_utils.type_int()},
    {"name": "name", "datatype": dbt_utils.type_string(), "alias": "brand_name"},
    {"name": "subdomain", "datatype": dbt_utils.type_string()},
    {"name": "url", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_zendesk_ticket_form_history_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "active", "datatype": "boolean", "alias": "is_active"},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "display_name", "datatype": dbt_utils.type_string()},
    {"name": "end_user_visible", "datatype": "boolean"},
    {"name": "id", "datatype": dbt_utils.type_int(), "alias": "ticket_form_id"},
    {"name": "name", "datatype": dbt_utils.type_string(), "alias": "ticket_form_name"},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_zendesk_ticket_field_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "field_name", "datatype": dbt_utils.type_string()},
    {"name": "ticket_id", "datatype": dbt_utils.type_int()},
    {"name": "updated", "datatype": dbt_utils.type_timestamp(), "alias": "valid_starting_at"},
    {"name": "user_id", "datatype": dbt_utils.type_int()},
    {"name": "value", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_zendesk_ticket_comment_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_string()},
    {"name": "body", "datatype": dbt_utils.type_string()},
    {"name": "call_duration", "datatype": dbt_utils.type_int()},
    {"name": "call_id", "datatype": dbt_utils.type_int()},
    {"name": "created", "datatype": dbt_utils.type_timestamp()},
    {"name": "facebook_comment", "datatype": "boolean", "alias": "is_facebook_comment"},
    {"name": "id", "datatype": dbt_utils.type_int(), "alias": "ticket_comment_id"},
    {"name": "location", "datatype": dbt_utils.type_int()},
    {"name": "public", "datatype": "boolean", "alias": "is_public"},
    {"name": "recording_url", "datatype": dbt_utils.type_int()},
    {"name": "started_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "ticket_id", "datatype": dbt_utils.type_int()},
    {"name": "transcription_status", "datatype": dbt_utils.type_int()},
    {"name": "transcription_text", "datatype": dbt_utils.type_int()},
    {"name": "trusted", "datatype": dbt_utils.type_int()},
    {"name": "tweet", "datatype": "boolean", "alias": "is_tweet"},
    {"name": "user_id", "datatype": dbt_utils.type_int()},
    {"name": "voice_comment", "datatype": "boolean", "alias": "is_voice_comment"},
    {"name": "voice_comment_transcription_visible", "datatype": dbt_utils.type_int()}
] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_zendesk_user_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "active", "datatype": "boolean", "alias": "is_active"},
    {"name": "alias", "datatype": dbt_utils.type_string()},
    {"name": "authenticity_token", "datatype": dbt_utils.type_int()},
    {"name": "chat_only", "datatype": "boolean"},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "details", "datatype": dbt_utils.type_int()},
    {"name": "email", "datatype": dbt_utils.type_string(), "alias": "user_email"},
    {"name": "external_id", "datatype": dbt_utils.type_int()},
    {"name": "id", "datatype": dbt_utils.type_int(), "alias": "user_id"},
    {"name": "last_login_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "locale", "datatype": dbt_utils.type_string()},
    {"name": "locale_id", "datatype": dbt_utils.type_int()},
    {"name": "moderator", "datatype": "boolean"},
    {"name": "name", "datatype": dbt_utils.type_string(), "alias": "user_name"},
    {"name": "notes", "datatype": dbt_utils.type_int()},
    {"name": "only_private_comments", "datatype": "boolean"},
    {"name": "organization_id", "datatype": dbt_utils.type_int()},
    {"name": "phone", "datatype": dbt_utils.type_int()},
    {"name": "remote_photo_url", "datatype": dbt_utils.type_int()},
    {"name": "restricted_agent", "datatype": "boolean"},
    {"name": "role", "datatype": dbt_utils.type_string(), "alias": "user_role"},
    {"name": "shared", "datatype": "boolean"},
    {"name": "shared_agent", "datatype": "boolean"},
    {"name": "signature", "datatype": dbt_utils.type_int()},
    {"name": "suspended", "datatype": "boolean", "alias": "is_suspended"},
    {"name": "ticket_restriction", "datatype": dbt_utils.type_string()},
    {"name": "time_zone", "datatype": dbt_utils.type_string()},
    {"name": "two_factor_auth_enabled", "datatype": "boolean"},
    {"name": "updated_at", "datatype": dbt_utils.type_string()},
    {"name": "url", "datatype": dbt_utils.type_string()},
    {"name": "verified", "datatype": "boolean"}
] %}

{{ return(columns) }}

{% endmacro %}

{% macro get_zendesk_user_tag_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "user_id", "datatype": dbt_utils.type_int()},
    {"name": "TAG", "datatype": dbt_utils.type_string(), "quote": True, 'alias': "tags" }
] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_zendesk_group_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "id", "datatype": dbt_utils.type_int(), "alias": "group_id"},
    {"name": "name", "datatype": dbt_utils.type_string(), "alias": "group_name"},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "url", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_zendesk_organization_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "details", "datatype": dbt_utils.type_int()},
    {"name": "external_id", "datatype": dbt_utils.type_int()},
    {"name": "group_id", "datatype": dbt_utils.type_int()},
    {"name": "id", "datatype": dbt_utils.type_int(), "alias": "organization_id"},
    {"name": "name", "datatype": dbt_utils.type_string(), "alias": "organization_name"},
    {"name": "notes", "datatype": dbt_utils.type_int()},
    {"name": "shared_comments", "datatype": "boolean"},
    {"name": "shared_tickets", "datatype": "boolean"},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "url", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}


{% macro get_zendesk_organization_tag_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "organization_id", "datatype": dbt_utils.type_int()},
    {"name": "TAG", "datatype": dbt_utils.type_string(), "quote": True, "alias": "tags" }
] %}


{{ return(columns) }}

{% endmacro %}

{% macro get_zendesk_domain_name_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "domain_name", "datatype": dbt_utils.type_string()},
    {"name": "index", "datatype": dbt_utils.type_int()},
    {"name": "organization_id", "datatype": dbt_utils.type_int()}
] %}

{{ return(columns) }}

{% endmacro %}


