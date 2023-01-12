with opportunity_agg as (
    select * from {{ ref('fct__outreach_sf__opportunity_by_account') }}

),

pivot as (
    select
        opportunity_agg.dbt_updated_at,
        opportunity_agg.opportunity_id,
        opportunity_agg.count_won,
        opportunity_agg.count_lost,
        opportunity_agg.count_closed,
        opportunity_agg.count_open,
        opportunity_agg.account_id,
        opportunity_agg.account_name,
        opportunity_agg.account_host,
        opportunity_agg.number_of_employees,
        opportunity_agg.industry,
        opportunity_agg.billing_country,
        opportunity_agg.buyer_intent_score,
        opportunity_agg.account_created_at,
        opportunity_agg.opportunity_probability,
        opportunity_agg.domain,

             {{ dbt_utils.pivot( 
                 'opportunity_status',
                 dbt_utils.get_column_values(ref('fct__outreach_sf__opportunity_by_account'), 'opportunity_status'),
                 agg='boolor_agg',
                 then_value='is_effective',
                 else_value='false',
                 prefix='is_',
                 suffix='_effective'
             ) }},

             {{ dbt_utils.pivot( 
                 'opportunity_status',
                 dbt_utils.get_column_values(ref('fct__outreach_sf__opportunity_by_account'), 'opportunity_status'),
                 agg='sum',
                 then_value='amount',
                 else_value=0,
                 prefix='',
                 suffix='_amount'
             ) }}

    from opportunity_agg
    {{ dbt_utils.group_by(n=16) }}
)

select * from pivot
