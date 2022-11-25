{{ config(enabled = var('hubspot__deal_stage') ) }}

with deals as (

    select *
    from {{ ref('base__hubspot__deal') }}

),

deal_stage as (

    select *
    from {{ ref('base__hubspot__deal_stage') }}

),

pipeline_stage as (

    select *
    from {{ ref('base__hubspot__deal_pipeline_stage') }}

),

pipeline as (

    select *
    from {{ ref('base__hubspot__deal_pipeline') }}

),

final as (

    select
        deal_stage.deal_id || '-' || row_number() over(partition by deal_stage.deal_id order by deal_stage.deal_stage_entered asc) as deal_stage_id,
        deals.deal_id,
        deals.deal_name,
        deal_stage._fivetran_start,
        deal_stage._fivetran_end,
        deal_stage._fivetran_active,

        deal_stage.deal_stage_name,
        pipeline_stage.pipeline_stage_label,
        pipeline_stage.deal_pipeline_id,
        pipeline.pipeline_label,
        deal_stage.source,
        deal_stage.source_id,
        pipeline_stage.is_pipeline_stage_active,
        pipeline.is_pipeline_active,
        pipeline_stage.is_pipeline_stage_closed_won,
        pipeline_stage.pipeline_stage_display_order,
        pipeline.pipeline_display_order,
        pipeline_stage.pipeline_stage_probability

    from deal_stage

    left join deals
        on deal_stage.deal_id = deals.deal_id

    left join pipeline_stage
        on deals.deal_pipeline_stage_id = pipeline_stage.deal_pipeline_stage_id

    left join pipeline
        on pipeline_stage.deal_pipeline_id = pipeline.deal_pipeline_id
)

select *
from final
