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
        -- account.industry,
        account.buyer_intent_score,
        account.account_created_at,
        account.domain,
        -- account.external_source,
        -- account.followers,
        -- account.billing_city,
        -- account.billing_street,
        account.billing_country,
        account.billing_postal_code,
        -- account.last_referenced_date,
        count(opportunity.opportunity_id) as number_of_opportunity,
        sum(opportunity.amount_won) as amount_won,
        sum(opportunity.amount_lost) as amount_lost,
        avg(opportunity.opportunity_probability) as opportunity_probability,
        sum(opportunity.count_won) as count_won,
        sum(opportunity.count_lost) as count_lost,
        sum(opportunity.count_pipeline) as count_pipeline,
        sum(opportunity.count_closed) as count_closed,
        sum(opportunity.count_open) as count_open

    from account
    left join opportunity on account.sf_account_id = opportunity.sf_account_id
        or account.outreach_account_id = opportunity.outreach_account_id
    group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12

),


final as (
    select
        *,
        case
            when count_won < 1 and count_closed > 0 then 'lost_customer' -- customer with no won case 
            when count_won < 0 and count_closed > 0 then 'customer' -- customer with at least 1 won case
            when count_open > 0 and count_won = 0 and count_lost = 0 then 'prospective'
            when number_of_opportunity < 1 then 'lead' -- customer with no open case
            else 'other'
        end as account_status
    from joined

)

select * from final
