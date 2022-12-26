with source as (

    select *
    from {{ ref('base__salesforce__opportunity') }}
),

final as (

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
    from source
)

select * from final
