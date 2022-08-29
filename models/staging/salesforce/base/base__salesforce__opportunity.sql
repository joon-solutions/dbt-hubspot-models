
with source as (
    
    select * from {{ source('salesforce', 'opportunity') }}
),

renamed as (
    
    select 
        -- cast(_fivetran_synced as {{ dbt_utils.type_timestamp() }}) as _fivetran_synced,
        account_id,
        cast(amount as {{ dbt_utils.type_numeric() }}) as amount,
        campaign_id,
        cast(close_date as {{ dbt_utils.type_timestamp() }}) as close_date,
        cast(created_date as {{ dbt_utils.type_timestamp() }}) as created_date,
        description as opportunity_description,
        cast(expected_revenue as {{ dbt_utils.type_numeric() }}) as expected_revenue,
        fiscal,
        fiscal_quarter,
        fiscal_year,
        forecast_category,
        forecast_category_name,
        has_open_activity,
        has_opportunity_line_item,
        has_overdue_task,
        id as opportunity_id,
        is_closed,
        -- is_deleted,
        is_won,
        cast(last_activity_date as {{ dbt_utils.type_timestamp() }}) as last_activity_date,
        cast(last_referenced_date as {{ dbt_utils.type_timestamp() }}) as last_referenced_date,
        cast(last_viewed_date as {{ dbt_utils.type_timestamp() }}) as last_viewed_date,
        lead_source,
        name as opportunity_name,
        next_step,
        owner_id,
        probability,
        record_type_id,
        stage_name,
        synced_quote_id,
        type

        --The below script allows for pass through columns.
        {% if var('opportunity_pass_through_columns',[]) != [] %}
        , {{ var('opportunity_pass_through_columns') | join (", ")}}

        {% endif %}

    from source
)

select * from renamed

