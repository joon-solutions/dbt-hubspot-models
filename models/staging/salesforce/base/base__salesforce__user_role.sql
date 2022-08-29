--To disable this model, set the below variable within your dbt_project.yml file to False.
{{ config(enabled=var('salesforce__user_role_enabled', True)) }}

with source as (

    select * from {{ source('salesforce', 'user_role') }}

),

renamed as (
    
    select
        _fivetran_deleted,
        cast(_fivetran_synced as {{ dbt_utils.type_timestamp() }}) as _fivetran_synced,
        developer_name,
        id as user_role_id,
        name as user_role_name,
        opportunity_access_for_account_owner,
        parent_role_id,
        rollup_description

        --The below script allows for pass through columns.
        {% if var('user_role_pass_through_columns',[]) != [] %}
        , {{ var('user_role_pass_through_columns') | join (", ")}}

        {% endif %}
        
    from source
)

select * from renamed

