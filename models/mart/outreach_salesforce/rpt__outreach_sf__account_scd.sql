with opportunity_pivot as (
    select * from {{ ref('rpt__outreach_sf__opportunity_scd_pivot') }}

),

joined as (
    select
        account_id,
        dbt_updated_at,
        account_host,
        account_name,
        number_of_employees,
        industry,
        buyer_intent_score,
        account_created_at,
        domain,
        billing_country,
        coalesce(count(opportunity_id), 0) as number_of_opportunity,
        coalesce(sum("Won_amount"), 0) as amount_won,
        coalesce(sum("Lost_amount"), 0) as amount_lost,
        coalesce(avg(opportunity_probability), 0) as opportunity_probability,
        coalesce(sum(count_won), 0) as count_won,
        coalesce(sum(count_lost), 0) as count_lost,
        coalesce(sum(count_closed), 0) as count_closed,
        coalesce(sum(count_open), 0) as count_open

    from opportunity_pivot
    {{ dbt_utils.group_by(n=10) }}

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
    {{ dbt_utils.surrogate_key(['account_id','dbt_updated_at']) }} as id
from final
