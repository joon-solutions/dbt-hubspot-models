--To disable this model, set the below variable within your dbt_project.yml file to False.
{{ config(enabled=var('salesforce__opportunity_enabled', False)) }}

with source as (

    select * from {{ source('salesforce', 'opportunity') }}

),

renamed as (
    select

        {{
        fivetran_utils.fill_staging_columns(
            source_columns=adapter.get_columns_in_relation(source('salesforce', 'opportunity')),
            staging_columns = get_salesforce_opportunity_columns()
        )
    }}

        --The below script allows for pass through columns.
        {% if var('opportunity_pass_through_columns',[]) != [] %},
        {{ var('opportunity_pass_through_columns') | join (", ") }}
    {% endif %}

    from source
),


final as (

    select
        opportunity_id,
        pricebook_2_id,
        opportunity_type,
        has_opportunity_line_item,
        cast(_fivetran_synced as {{ dbt_utils.type_timestamp() }}) as _fivetran_synced,
        forecast_category,
        opportunity_name,
        account_id,
        owner_id,
        is_won,
        stage_name,
        next_step,
        forecast_category_name,
        campaign_id,
        cast(close_date as {{ dbt_utils.type_timestamp() }}) as close_date,
        cast(created_date as {{ dbt_utils.type_timestamp() }}) as created_date,
        record_type_id,
        opportunity_description,
        amount,
        is_deleted,
        lead_source,
        opportunity_probability,
        is_closed,
        updated_at

        --The below script allows for pass through columns.
        {% if var('opportunity_pass_through_columns',[]) != [] %},
            {{ var('opportunity_pass_through_columns') | join (", ") }}
        {% endif %}

    from renamed
)

select * from final
