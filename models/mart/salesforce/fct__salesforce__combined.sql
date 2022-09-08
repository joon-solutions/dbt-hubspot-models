with opportunity as (

    select *
    from {{ ref('stg__salesforce__opportunity') }}
),

users as (

    select *
    from {{ ref('base__salesforce__user') }}
),

user_role as (

    select *
    from {{ ref('base__salesforce__user_role') }}
),

account as (

    select *
    from {{ ref('base__salesforce__account') }}
),

joined as (

    select
        opportunity.*,
        account.account_source,
        account.industry,
        account.account_name,
        account.number_of_employees,
        account.account_type,
        opportunity_owner.user_id as opportunity_owner_id,
        opportunity_owner.user_name as opportunity_owner_name,
        opportunity_owner.user_role_id as opportunity_owner_role_id,
        opportunity_owner.city as opportunity_owner_city,
        opportunity_owner.state as opportunity_owner_state,
        opportunity_manager.user_id as opportunity_manager_id,
        opportunity_manager.user_name as opportunity_manager_name,
        opportunity_manager.city as opportunity_manager_city,
        opportunity_manager.state as opportunity_manager_state,

        -- If using user_role table, the following will be included, otherwise it will not.
        {% if var('salesforce__user_role_enabled', True) %}
            user_role.user_role_name as opportunity_owner_position,
            user_role.developer_name as opportunity_owner_developer_name,
            user_role.parent_role_id as opportunity_owner_parent_role_id,
            user_role.rollup_description as opportunity_owner_rollup_description,
        {% endif %}

        case
            when opportunity.is_won then 'Won'
            when not opportunity.is_won and opportunity.is_closed then 'Lost'
            when not opportunity.is_closed and lower(opportunity.forecast_category) in ('pipeline', 'forecast', 'bestcase') then 'Pipeline'
            else 'Other'
        end as status,
        case when opportunity.is_created_this_month then opportunity.amount else 0 end as created_amount_this_month,
        case when opportunity.is_created_this_quarter then opportunity.amount else 0 end as created_amount_this_quarter,
        case when opportunity.is_closed_this_month then opportunity.amount else 0 end as closed_amount_this_month,
        case when opportunity.is_closed_this_quarter then opportunity.amount else 0 end as closed_amount_this_quarter

        --The below script allows for pass through columns.

        {% if var('opportunity_enhanced_pass_through_columns',[]) != [] %},
            {{ var('opportunity_enhanced_pass_through_columns') | join (", ") }}
        {% endif %}

    from opportunity
    left join account
        on opportunity.account_id = account.account_id --many-to-one
    left join users as opportunity_owner
        on opportunity.owner_id = opportunity_owner.user_id --many-to-one
    left join users as opportunity_manager
        on opportunity_owner.manager_id = opportunity_manager.user_id --many-to-one

    -- If using user_role table, the following will be included, otherwise it will not.
    {% if var('salesforce__user_role_enabled', True) %}
        left join user_role
            on opportunity_owner.user_role_id = user_role.user_role_id --many-to-one

    {% endif %}
)

select * from joined
