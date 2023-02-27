with account as (
    select *
    from {{ ref('int__salesforce__opportunity_account') }}
),

account_agg as (
    select
        account_id,
        account_name,
        account_host,
        industry,
        coalesce(count(opportunity_id), 0) as opportunity_count,
        coalesce(sum(case when opportunity_status = 'Won' then amount else 0 end), 0) as total_amount_won,
        coalesce(sum(case when opportunity_status = 'Lost' then amount else 0 end), 0) as total_amount_lost,
        coalesce(sum(case when opportunity_status in ('Pipeline', 'Other') then amount else 0 end), 0) as total_amount_open,
        ----
        coalesce(count(case when opportunity_status = 'Won' then opportunity_id end), 0) as won_deals_count,
        coalesce(count(case when opportunity_status = 'Lost' then opportunity_id end), 0) as lost_deals_count,
        coalesce(count(case when opportunity_status in ('Pipeline', 'Other') then opportunity_id end), 0) as open_deals_count
    from account
    {{ dbt_utils.group_by(n=4) }}
),

account_status as (
    select
        *,
        case
            when won_deals_count = 0 and open_deals_count > 0 then 'lost_customer' -- customer with no won case 
            when won_deals_count > 0 then 'customer' -- customer with at least 1 won case
            when open_deals_count > 0 and won_deals_count + lost_deals_count = 0 then 'prospective'
            when opportunity_count = 0 then 'lead' -- customer with no open case
            else 'other'
        end as account_status
    from account_agg
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
        account_status.account_id,
        account_status.account_status,
        account_status.opportunity_count,
        account_status.total_amount_won,
        account_status.total_amount_lost,
        account_status.total_amount_open,
        account_status.won_deals_count,
        account_status.lost_deals_count,
        account_status.open_deals_count,
        ---if multiple leads are mapped with 1 opportunity_id, such opportunity's amount & count will be divided equally for each corresponding lead's source
        account_status.opportunity_count / count(*) over (partition by account_status.account_id) as adjusted_opportunity_count,
        account_status.total_amount_won / count(*) over (partition by account_status.account_id) as adjusted_total_amount_won,
        account_status.total_amount_lost / count(*) over (partition by account_status.account_id) as adjusted_total_amount_lost,
        account_status.total_amount_open / count(*) over (partition by account_status.account_id) as adjusted_total_amount_open,
        account_status.won_deals_count / count(*) over (partition by account_status.account_id) as adjusted_won_deals_count,
        account_status.lost_deals_count / count(*) over (partition by account_status.account_id) as adjusted_lost_deals_count,
        account_status.open_deals_count / count(*) over (partition by account_status.account_id) as adjusted_open_deals_count

    from lead
    left join account_status on lead.account_id = account_status.account_id --many-to-one
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
        coalesce(count(distinct case when account_status = 'prospective' then account_id end), 0) as unique_prospective_count, -- having at least 1 open deal at the moment
        coalesce(count(distinct case when account_status = 'lost_customer' then account_id end), 0) as unique_lost_customers_count, -- customer with no won case 
        coalesce(count(distinct case when account_status = 'customer' then account_id end), 0) as unique_customers_count --won at least 1 deals
    from joined
    {{ dbt_utils.group_by(n=4) }}
)

select
    *,
    {{ dbt_utils.surrogate_key(['lead_source','utm_medium','utm_source','utm_campaign']) }} as id
from final
