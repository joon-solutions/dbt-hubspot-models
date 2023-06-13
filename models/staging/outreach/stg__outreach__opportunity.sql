{{ config(enabled = var('outreach_opportunity', False) ) }}

with opportunity as (
    select *
    from {{ ref('base__outreach__opportunity') }}
),

opportunity_stage as (
    select *
    from {{ ref('base__outreach__opportunity_stage') }}
),

final as (
    select
        opportunity.*,
        opportunity_stage.opportunity_stage_name,
        opportunity_stage.is_closed,
        case when opportunity_stage.opportunity_stage_name = 'Closed Won' then 'Won'
            when opportunity_stage.opportunity_stage_name = 'Closed Lost' then 'Lost'
            else 'Pipeline'
        end as opportunity_status
    from opportunity
    left join opportunity_stage on opportunity.opportunity_stage_id = opportunity_stage.opportunity_stage_id --many-to-one
)

select * from final
