with account as (
    select * from {{ ref('base__salesforce__account') }}
),

opportunity as (
    select * from {{ ref('base__salesforce__opportunity') }}
),

joined as (
    select
        account.account_id,
        account.account_source,
        account.account_name,
        account.account_description,
        account.account_type,
        account.number_of_employees,
        account.industry,
        opportunity.opportunity_id,
        opportunity.opportunity_type,
        opportunity.has_opportunity_line_item,
        opportunity.opportunity_name,
        opportunity.forecast_category,
        opportunity.is_won,
        opportunity.stage_name,
        opportunity.next_step,
        opportunity.forecast_category_name,
        opportunity.close_date,
        opportunity.created_date,
        opportunity.amount,
        opportunity.probability,
        opportunity.is_closed,
        {{ dbt_utils.surrogate_key(['account.account_id','opportunity.opportunity_id']) }} as id

    from account
    left join opportunity on account.account_id = opportunity.opportunity_id
)

select * from joined