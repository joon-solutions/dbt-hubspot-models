{{ config(enabled = var('hubspot__deal') and var('hubspot__owner') ) }}


with deals as (

    select *
    from {{ ref('base__hubspot__deal') }}

),

pipelines as (

    select *
    from {{ ref('base__hubspot__deal_pipeline') }}

),

pipeline_stages as (

    select *
    from {{ ref('base__hubspot__deal_pipeline_stage') }}

),

owners as (

    select *
    from {{ ref('base__hubspot__owner') }}

),

deal_fields_joined as (

    select
        deals.*,
        pipelines.pipeline_label,
        pipelines.is_pipeline_active,
        pipeline_stages.pipeline_stage_label,
        owners.email_address as owner_email_address,
        owners.full_name as owner_full_name

    from deals
    left join pipelines
        on deals.deal_pipeline_id = pipelines.deal_pipeline_id
    left join pipeline_stages
        on deals.deal_pipeline_stage_id = pipeline_stages.deal_pipeline_stage_id
    left join owners
        on deals.owner_id = owners.owner_id
)

select *
from deal_fields_joined
