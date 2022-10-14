{{ config(enabled=var('marketo__email_template_history', True)) }}

with base as (

    select *
    from {{ source('marketo', 'email_template_history') }}

),

macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('marketo', 'email_template_history')),
                staging_columns=get_marketo_email_template_history_columns()
            )
        }}
    from base

),

fields as (

    select
        created_timestamp,
        description,
        folder_name,
        folder_id,
        folder_type,
        folder_value,
        from_email,
        from_name,
        email_template_id,
        email_template_name,
        is_operational,
        program_id,
        publish_to_msi,
        reply_email,
        email_template_status,
        email_subject,
        parent_template_id,
        is_text_only,
        updated_timestamp,
        email_template_url,
        version_type,
        has_web_view_enabled,
        workspace_name
    from macro

),

versions as (

    select
        *,
        row_number() over (partition by email_template_id order by updated_timestamp) as inferred_version,
        count(*) over (partition by email_template_id) as total_count_of_versions
    from fields

),

valid as (

    select
        *,
        case
            when inferred_version = 1 then created_timestamp
            else updated_timestamp
        end as valid_from,
        lead(updated_timestamp) over (partition by email_template_id order by updated_timestamp) as valid_to,
        inferred_version = total_count_of_versions as is_most_recent_version
    from versions

),

surrogate_key as (

    select
        *,
        {{ dbt_utils.surrogate_key(['email_template_id','inferred_version']) }} as email_template_history_id
    from valid

)

select *
from surrogate_key
