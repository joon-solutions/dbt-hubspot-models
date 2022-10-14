{{ config(enabled=var('marketo__activity_click_email', True)) }}

with base as (

    select *
    from {{ source('marketo', 'activity_click_email') }}

),

macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('marketo', 'activity_click_email')),
                staging_columns=get_marketo_activity_click_email_columns()
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
        choice_number,
        click_device,
        email_template_id,
        activity_id,
        is_mobile_device,
        lead_id,
        click_link_url,
        user_platform,
        primary_attribute_value,
        primary_attribute_value_id,
        step_id,
        user_agent
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
