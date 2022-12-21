with outreach as (

    select
        opportunity_id as outreach_opportunity_id,
        opportunity_name,
        account_id as outreach_account_id,
        amount,
        close_date,
        opportunity_status,
        opportunity_probability,
        is_closed,
        created_at,
        'outreach' as source
    from {{ ref('stg__outreach__opportunity') }}
),

sf as (
    select
        opportunity_id as sf_opportunity_id,
        opportunity_name,
        account_id as sf_account_id,
        amount,
        close_date,
        opportunity_status,
        opportunity_probability,
        is_closed,
        created_date,
        'sf' as source
    from {{ ref('stg__salesforce__opportunity') }}
),

final as (
    select
        outreach.outreach_opportunity_id,
        outreach.outreach_account_id,
        sf.sf_opportunity_id,
        sf.sf_account_id,
        COALESCE(outreach.opportunity_name, sf.opportunity_name) as opportunity_name,
        COALESCE(outreach.amount, sf.amount) as amount,
        COALESCE(outreach.close_date, sf.close_date) as close_date,
        COALESCE(outreach.opportunity_status, sf.opportunity_status) as opportunity_status,
        COALESCE(outreach.opportunity_probability, sf.opportunity_probability) as opportunity_probability,
        COALESCE(outreach.is_closed, sf.is_closed) as is_closed,
        COALESCE(outreach.created_at, sf.created_date) as created_at,
        COALESCE(outreach.source, sf.source) as source,
        {{ dbt_utils.surrogate_key(['outreach.outreach_opportunity_id', 'sf.sf_opportunity_id']) }} as opportunity_id

    from outreach
    full outer join sf on outreach.opportunity_name = sf.opportunity_name
)

select * from final
