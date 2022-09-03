with source as (

    select * from {{ source('salesforce', 'opportunity') }}
),

renamed as (

    select
        id as opportunity_id,
        pricebook_2_id,
        type as opportunity_type,
        has_opportunity_line_item,
        cast(_fivetran_synced as {{ dbt_utils.type_timestamp() }}) as _fivetran_synced,
        forecast_category,
        name as opportunity_name,
        account_id,
        owner_id,
        is_won,
        stage_name,
        next_step,
        forecast_category_name,
        campaign_id,
        close_date,
        record_type_id,
        description as opportunity_description,
        amount,
        is_deleted,
        lead_source,
        probability,
        is_closed

        --The below script allows for pass through columns.
        {% if var('opportunity_pass_through_columns',[]) != [] %}
        , {{ var('opportunity_pass_through_columns') | join (", ") }}

        {% endif %}

    from source
)

select * from renamed
