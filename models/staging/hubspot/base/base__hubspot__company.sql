{{ config(enabled = var('hubspot__company', False) ) }}

with base as (

    select *
    from {{ source('hubspot', 'company') }}

),

macro as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('hubspot', 'company')),
                staging_columns=get_hubspot_company_columns()
            )
        }}
    from base

),

fields as (

    select
        -- if user chooses to pass through all columns
        {% if var('hubspot__pass_through_all_columns', false) %}
        id as company_id,
        property_name as company_name,
        
        {{ 
            fivetran_utils.remove_prefix_from_columns(
                columns=adapter.get_columns_in_relation(source('hubspot', 'company')), 
                prefix='property_', exclude=['id','property_name']
            ) 
        }}
    from base

        {% else %}
            -- if user chooses to pass only specified columns through
            *
        --The below macro adds the fields defined within your hubspot__company_pass_through_columns variable into the staging model
        {{ fivetran_utils.fill_pass_through_columns('hubspot__company_pass_through_columns') }}

        from macro

        {% endif %}
)

select *
from fields
where not coalesce(is_deleted, false)
