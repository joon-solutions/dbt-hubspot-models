{{ config(enabled = var('outreach_opportunity_stage') and var('salesforce__opportunity_enabled') ) }}

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
        case when opportunity.outreach_sf_valid_to is not null
                then opportunity.outreach_sf_valid_to >= base_dates.date_day
            else true
        end and opportunity.outreach_sf_valid_from <= base_dates.date_day as is_effective

    from opportunity
    left join base_dates on 1 = 1
),

account as (
    select * from {{ ref('int__outreach_sf__account') }}
),

joined as (
    select
        account.account_id,
        account.sf_account_id,
        account.outreach_account_id,
        account.account_host,
        account.account_name,
        account.number_of_employees,
        account.source,
        account.industry,
        account.buyer_intent_score,
        account.account_created_at,
        account.domain,
        account.billing_country,
        account.billing_postal_code,
        opportunity_agg.date_day,
        coalesce(count(opportunity_agg.opportunity_id), 0) as number_of_opportunity,
        coalesce(sum(opportunity_agg.amount_won), 0) as amount_won,
        coalesce(sum(opportunity_agg.amount_lost), 0) as amount_lost,
        coalesce(avg(opportunity_agg.opportunity_probability), 0) as opportunity_probability,
        coalesce(sum(opportunity_agg.count_won), 0) as count_won,
        coalesce(sum(opportunity_agg.count_lost), 0) as count_lost,
        coalesce(sum(opportunity_agg.count_closed), 0) as count_closed,
        coalesce(sum(opportunity_agg.count_open), 0) as count_open
    from account
    left join opportunity_agg on account.sf_account_id = opportunity_agg.sf_account_id
        or account.outreach_account_id = opportunity_agg.outreach_account_id
    where opportunity_agg.is_effective
    {{ dbt_utils.group_by(n=14) }}
),

final as (
    select
        *,
        case
            when count_won = 0 and count_closed > 0 then 'lost_customer' -- customer with no won case 
            when count_won > 0 and count_closed > 0 then 'customer' -- customer with at least 1 won case
            when count_open > 0 and count_closed = 0 then 'prospective'
            when number_of_opportunity = 0 then 'lead' -- customer with no open case
            else 'other'
        end as account_status
    from joined

)

select
    *,
    {{ dbt_utils.surrogate_key(['account_id', 'date_day']) }} as id
from final
