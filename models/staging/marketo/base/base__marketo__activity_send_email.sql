{{ config(enabled=var('marketo__activity_send_email', True)) }}

with base as (

    select *
    from {{ source('marketo', 'activity_send_email') }}

),

macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('marketo', 'activity_send_email')),
                staging_columns=get_marketo_activity_send_email_columns()
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
        email_template_id,
        activity_id,
        lead_id,
        primary_attribute_value,
        primary_attribute_value_id,
        step_id
    from macro

),

surrogate as (

    select
        *,
        {{ dbt_utils.surrogate_key(['primary_attribute_value_id','campaign_id','campaign_run_id','lead_id']) }} as email_send_id,
        row_number() over (partition by email_send_id order by activity_timestamp asc) as activity_rank
    from fields
    qualify activity_rank = 1

)

select *
from surrogate
