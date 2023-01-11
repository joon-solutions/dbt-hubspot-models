with account as (
    select * from {{ ref('int__outreach_sf__account') }}
),

opportunity as (
    select * from {{ ref('int__outreach_sf__opportunity') }}

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
        coalesce(count(opportunity.opportunity_id), 0) as number_of_opportunity,
        coalesce(sum(opportunity.amount_won), 0) as amount_won,
        coalesce(sum(opportunity.amount_lost), 0) as amount_lost,
        coalesce(avg(opportunity.opportunity_probability), 0) as opportunity_probability,
        coalesce(sum(opportunity.count_won), 0) as count_won,
        coalesce(sum(opportunity.count_lost), 0) as count_lost,
        coalesce(sum(opportunity.count_closed), 0) as count_closed,
        coalesce(sum(opportunity.count_open), 0) as count_open

    from account
    left join opportunity on account.sf_account_id = opportunity.sf_account_id
        or account.outreach_account_id = opportunity.outreach_account_id
    {{ dbt_utils.group_by(n=13) }}

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

select * from final
