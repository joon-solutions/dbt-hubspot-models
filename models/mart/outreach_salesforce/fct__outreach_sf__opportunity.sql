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
        user.user_phone_number as sales_rep_phone_number
    from opportunity
    left join user on opportunity.outreach_owner_id = user.outreach_user_id or opportunity.sf_owner_id = user.sf_user_id
)

select * from final