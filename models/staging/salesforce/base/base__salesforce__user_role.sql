--To disable this model, set the below variable within your dbt_project.yml file to False.
{{ config(enabled=var('salesforce__user_role_enabled', False)) }}

with source as (

    select * from {{ source('salesforce', 'user_role') }}

),

renamed as (

    select

    {{
        fivetran_utils.fill_staging_columns(
            source_columns=adapter.get_columns_in_relation(source('salesforce', 'user_role')),
            staging_columns = get_salesforce_user_role_columns()
        )
    }}

        --The below script allows for pass through columns.
        {% if var('user_role_pass_through_columns',[]) != [] %},
        {{ var('user_role_pass_through_columns') | join (", ") }}
    {% endif %}

    from source
),

final as (

    select
        developer_name,
        user_role_id,
        user_role_name,
        cast(_fivetran_synced as {{ dbt_utils.type_timestamp() }}) as _fivetran_synced,
        parent_role_id,
        rollup_description

        --The below script allows for pass through columns.
        {% if var('user_pass_through_columns',[]) != [] %},
            {{ var('user_pass_through_columns') | join (", ") }}
        {% endif %}

    from renamed
)

select * from final
