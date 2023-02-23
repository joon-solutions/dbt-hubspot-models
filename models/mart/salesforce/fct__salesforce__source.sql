with account as (
    select * 
    from {{ ref('int__salesforce__account') }}
),

lead as (
    select *
    from {{ ref('base__salesforce__lead') }}
),

joined as ( --PK = lead_id || account_id
    select 
        lead.lead_id,
        --source
        lead.lead_source,
        lead.utm_medium,
        lead.utm_source,
        lead.utm_campaign,
        ---account
        account.account_id,
        account.account_status,
        account.opportunity_count,
        account.total_amount_won,
        account.total_amount_lost,
        account.total_amount_open,
        account.won_deals_count,
        account.lost_deals_count,
        account.open_deals_count,
        ---adjusted opportunities metrics
        account.opportunity_count/ count(1) over (partition by account.account_id) as adjusted_opportunity_count,
        account.total_amount_won/ count(1) over (partition by account.account_id) as adjusted_total_amount_won,
        account.total_amount_lost/ count(1) over (partition by account.account_id) as adjusted_total_amount_lost,
        account.total_amount_open/ count(1) over (partition by account.account_id) as adjusted_total_amount_open,
        account.won_deals_count/ count(1) over (partition by account.account_id) as adjusted_won_deals_count,
        account.lost_deals_count/ count(1) over (partition by account.account_id) as adjusted_lost_deals_count,
        account.open_deals_count/ count(1) over (partition by account.account_id) as adjusted_open_deals_count

    from lead
    left join account on lead.account_id = account.account_id --many-to-one
),


final as (
    select 
            lead_source,
            utm_medium,
            utm_source,
            utm_campaign,
            ---opportunities
            coalesce(sum(adjusted_opportunity_count), 0) as total_opportunities,
            coalesce(sum(adjusted_won_deals_count), 0) as total_won_opportunities,
            coalesce(sum(adjusted_lost_deals_count), 0) as total_lost_opportunities,
            coalesce(sum(adjusted_open_deals_count), 0) as total_open_opportunities,
            coalesce(sum(adjusted_total_amount_won), 0) as total_won_amount,
            coalesce(sum(adjusted_total_amount_lost), 0) as total_lost_amount,
            coalesce(sum(adjusted_total_amount_open), 0) as total_open_amount,
            ---customers
            coalesce(count(distinct lead_id), 0) as unique_leads_count,
            coalesce(count(distinct case when account_status = 'prospective' then account_id else null end), 0) as unique_prospective_count, -- having at least 1 open deal at the moment
            coalesce(count(distinct case when account_status = 'lost_customer' then account_id else null end), 0) as unique_lost_customers_count, -- customer with no won case 
            coalesce(count(distinct case when account_status = 'customer' then account_id else null end), 0) as unique_customers_count --won at least 1 deals
    from joined
    {{ dbt_utils.group_by(n=4) }}
)

select  *,
        {{ dbt_utils.surrogate_key(['lead_source','utm_medium','utm_source','utm_campaign']) }} as id
from final