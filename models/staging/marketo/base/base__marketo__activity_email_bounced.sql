{{ config(enabled=var('marketo__activity_email_bounced', False )) }}

with base as (

    select *
    from {{ source('marketo', 'activity_email_bounced') }}

),

macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('marketo', 'activity_email_bounced')),
                staging_columns=get_marketo_activity_email_bounced_columns()
            )
        }}
    from base

),

fields as (

    select
        cast(activity_date as {{ dbt_utils.type_timestamp() }}) as activity_timestamp,
        activity_type_id,
        campaign_id,
        campaign_run_id,
        bounce_category,
        choice_number,
        details,
        email_address,
        email_template_id,
        activity_id,
        lead_id,
        primary_attribute_value,
        primary_attribute_value_id,
        step_id,
        bounce_subcategory
    from macro

),

surrogate as (

    select
        *,
        {{ dbt_utils.surrogate_key(['primary_attribute_value_id','campaign_id','campaign_run_id','lead_id']) }} as email_send_id
    from fields

)

select *
from surrogate
