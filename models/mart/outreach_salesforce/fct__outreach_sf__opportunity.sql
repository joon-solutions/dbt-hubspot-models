{{ config(enabled = var('outreach_opportunity', False) and var('salesforce__opportunity_enabled', False)) }}

with opportunity as (
    select *
    from {{ ref('int__outreach_sf__opportunity') }}
),

user as (
    select *
    from {{ ref('int__outreach_sf__user') }}
),

final as (
    select
        opportunity.*,
        user.user_email as sales_rep_email,
        user.user_name as sales_rep_name,
        user.user_title as sales_rep_title,
        user.user_phone_number as sales_rep_phone_number,
        ---- In case 1 opportunity is associated with >1 sales rep, only take 1 into account
        row_number() over (partition by opportunity.opportunity_id order by user.updated_at desc) as rnk
    from opportunity
    left join user on opportunity.outreach_owner_id = user.outreach_user_id or opportunity.sf_owner_id = user.sf_user_id
    qualify rnk = 1
)

select * from final
