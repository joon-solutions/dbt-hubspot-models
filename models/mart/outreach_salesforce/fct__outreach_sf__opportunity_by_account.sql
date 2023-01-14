with opportunity as (
    select * from {{ ref('int__outreach_sf__opportunity_scd') }}
),

base_dates as (
    select *
    from {{ ref('base__dates') }}
    where date_day <= current_date() --UTC timezone
),

opportunity_agg as (
    select
        opportunity.*,
        base_dates.date_day,
        case when opportunity.dbt_valid_to is not null
                then opportunity.dbt_valid_to >= base_dates.date_day
            else true
        end and opportunity.created_at <= base_dates.date_day as is_effective

    from opportunity
    left join base_dates on 1 = 1
),

account as (
    select * from {{ ref('int__outreach_sf__account') }}
),

joined as (
    select
        opportunity_agg.*,
        account.account_name,
        account.account_host,
        account.number_of_employees,
        account.industry,
        account.account_id,
        account.billing_country,
        account.billing_postal_code,
        account.buyer_intent_score,
        account.account_created_at,
        account.domain

    from opportunity_agg
    left join account on opportunity_agg.outreach_account_id = account.outreach_account_id
        or opportunity_agg.sf_account_id = account.sf_account_id
    where opportunity_agg.is_effective
)

select * from joined
