with opportunity as (

    select *
    from {{ ref('base__salesforce__opportunity') }}
),

users as (

    select *
    from {{ ref('base__salesforce__user') }}
),

user_role as (

    select *
    from {{ ref('base__salesforce__user_role') }}
),

opportunity_agg as (

    select
        *,
        case
            when is_won then 'Won'
            when not is_won and is_closed then 'Lost'
            when not is_closed and lower(forecast_category) in ('pipeline', 'forecast', 'bestcase') then 'Pipeline'
            else 'Other'
        end as opportunity_status,
        created_date >= {{ dbt_utils.date_trunc('month', dbt_utils.current_timestamp()) }} as is_created_this_month,
        created_date >= {{ dbt_utils.date_trunc('quarter', dbt_utils.current_timestamp()) }} as is_created_this_quarter,
        {{ dbt_utils.datediff(dbt_utils.current_timestamp(), 'created_date', 'day') }} as days_since_created,
        {{ dbt_utils.datediff('close_date', 'created_date', 'day') }} as days_to_close,
        {{ dbt_utils.date_trunc('month', 'close_date') }} = {{ dbt_utils.date_trunc('month', dbt_utils.current_timestamp()) }} as is_closed_this_month,
        {{ dbt_utils.date_trunc('quarter', 'close_date') }} = {{ dbt_utils.date_trunc('quarter', dbt_utils.current_timestamp()) }} as is_closed_this_quarter
    from opportunity
),

joined as (

    select
        opportunity_agg.*,
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

        case when opportunity_agg.is_won then opportunity_agg.amount else 0 end as amount_won,
        case when not opportunity_agg.is_won and opportunity_agg.is_closed then opportunity_agg.amount else 0 end as amount_lost,
        case when opportunity_agg.is_created_this_month then opportunity_agg.amount else 0 end as created_amount_this_month,
        case when opportunity_agg.is_created_this_quarter then opportunity_agg.amount else 0 end as created_amount_this_quarter,
        case when opportunity_agg.is_closed_this_month then opportunity_agg.amount else 0 end as closed_amount_this_month,
        case when opportunity_agg.is_closed_this_quarter then opportunity_agg.amount else 0 end as closed_amount_this_quarter,
        case when is_created_this_month then 1 else 0 end as created_count_this_month,
        case when is_created_this_quarter then 1 else 0 end as created_count_this_quarter,
        case when is_closed_this_month then 1 else 0 end as closed_count_this_month,
        case when is_closed_this_quarter then 1 else 0 end as closed_count_this_quarter


        --The below script allows for pass through columns.

        {% if var('opportunity_enhanced_pass_through_columns',[]) != [] %},
            {{ var('opportunity_enhanced_pass_through_columns') | join (", ") }}
        {% endif %}

    from opportunity_agg
    left join users as opportunity_owner
        on opportunity_agg.owner_id = opportunity_owner.user_id --many-to-one
    left join users as opportunity_manager
        on opportunity_owner.manager_id = opportunity_manager.user_id --many-to-one

    -- If using user_role table, the following will be included, otherwise it will not.
    {% if var('salesforce__user_role_enabled', True) %}
        left join user_role
            on opportunity_owner.user_role_id = user_role.user_role_id --many-to-one

    {% endif %}
)

select * from joined
