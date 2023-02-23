with opportunity as (

    select *
    from {{ ref('stg__salesforce__opportunity') }}
),

account as (

    select *
    from {{ ref('base__salesforce__account') }}
),

joined as (
    select 
        account.account_id,
        account_name,
        account_host,
        industry,
        coalesce(count(opportunity.opportunity_id), 0) as opportunity_count,
        coalesce(sum(case when opportunity.opportunity_status = 'Won' then opportunity.amount else 0 end), 0) as total_amount_won,
        coalesce(sum(case when opportunity.opportunity_status = 'Lost' then opportunity.amount else 0 end), 0) as total_amount_lost,
        coalesce(sum(case when opportunity.opportunity_status in ('Pipeline', 'Other') then opportunity.amount else 0 end), 0) as total_amount_open,
        ----
        coalesce(count(case when opportunity.opportunity_status = 'Won' then opportunity.opportunity_id else null end), 0) as won_deals_count,
        coalesce(count(case when opportunity.opportunity_status = 'Lost' then opportunity.opportunity_id else null end), 0) as lost_deals_count,
        coalesce(count(case when opportunity.opportunity_status in ('Pipeline', 'Other') then opportunity.opportunity_id else null end), 0) as open_deals_count
    from account
    left join opportunity
    {{ dbt_utils.group_by(n=4) }}
),

final as (
    select
        *,
        case
            when won_deals_count = 0 and open_deals_count > 0 then 'lost_customer' -- customer with no won case 
            when won_deals_count > 0 then 'customer' -- customer with at least 1 won case
            when open_deals_count > 0 and won_deals_count + lost_deals_count = 0 then 'prospective'
            when opportunity_count = 0 then 'lead' -- customer with no open case
            else 'other'
        end as account_status
    from joined

)

select * from final