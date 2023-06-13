{{ config(enabled = var('outreach_opportunity_stage', False) and var('salesforce__opportunity_enabled', False) ) }}

with outreach as (

    select
        opportunity_id as outreach_opportunity_id,
        opportunity_name,
        account_id as outreach_account_id,
        owner_id as outreach_owner_id,
        amount,
        close_date,
        opportunity_status,
        opportunity_probability,
        is_closed,
        created_at,
        updated_at,
        'outreach' as source,
        dbt_updated_at,
        dbt_valid_from,
        -- cast the field to future dates to avoid null fields
        coalesce(dbt_valid_to, cast('{{ var("future_proof_date") }}' as timestamp)) as valid_to

    from {{ ref('stg__outreach__opportunity_scd') }}
),

sf as (
    select
        opportunity_id as sf_opportunity_id,
        opportunity_name,
        account_id as sf_account_id,
        owner_id as sf_owner_id,
        amount,
        close_date,
        opportunity_status,
        opportunity_probability,
        is_closed,
        created_date,
        updated_at,
        'sf' as source,
        dbt_updated_at,
        dbt_valid_from,
        -- cast the field to future dates to avoid null fields
        coalesce(dbt_valid_to, cast('{{ var("future_proof_date") }}' as timestamp)) as valid_to
    from {{ ref('stg__salesforce__opportunity_scd') }}
),

joined as (
    select
        outreach.outreach_opportunity_id,
        outreach.outreach_account_id,
        outreach.outreach_owner_id,
        sf.sf_opportunity_id,
        sf.sf_account_id,
        sf.sf_owner_id,
        coalesce(outreach.opportunity_name, sf.opportunity_name) as opportunity_name,
        coalesce(outreach.amount, sf.amount) as amount,
        coalesce(outreach.close_date, sf.close_date) as close_date,
        coalesce(outreach.opportunity_status, sf.opportunity_status) as opportunity_status,
        coalesce(outreach.opportunity_probability, sf.opportunity_probability) as opportunity_probability,
        coalesce(outreach.is_closed, sf.is_closed) as is_closed,
        coalesce(outreach.created_at, sf.created_date) as created_at,
        coalesce(outreach.source, sf.source) as source,
        coalesce(outreach.updated_at, sf.updated_at) as updated_at,
        coalesce(outreach.dbt_updated_at, sf.dbt_updated_at) as dbt_updated_at,
        outreach.valid_to as outreach_valid_to,
        sf.valid_to as salesforce_valid_to,
        {{ join_snapshots(
                'outreach', 
                'sf', 
                'valid_to',
                'dbt_valid_from', 
                'valid_to', 
                'dbt_valid_from',
                'opportunity_name', 
                'opportunity_name') }}
),

final as (
    select
        *,
        {{ dbt_utils.surrogate_key(['outreach_opportunity_id', 'sf_opportunity_id','outreach_sf_valid_to','outreach_sf_valid_from']) }} as opportunity_scd_id,
        {{ dbt_utils.surrogate_key(['outreach_opportunity_id', 'sf_opportunity_id']) }} as opportunity_id,
        case when
            opportunity_status = 'Won' then 1
            else 0 end as count_won,

        case when
            opportunity_status = 'Lost' then 1
            else 0 end as count_lost,

        case when
            opportunity_status = 'Pipeline' then 1
            else 0 end as count_pipeline,

        case when
            opportunity_status = 'Other' then 1
            else 0 end as count_other,

        case
            when is_closed then 1
            else 0 end as count_closed,

        case
            when is_closed = 0 then 1
            else 0 end as count_open
    from joined
)

select
    *,
    case when count_won > 0 then amount else 0 end as amount_won,
    case when count_lost > 0 then amount else 0 end as amount_lost
from final
