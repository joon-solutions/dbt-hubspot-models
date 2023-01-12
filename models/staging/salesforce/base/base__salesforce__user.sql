--To disable this model, set the below variable within your dbt_project.yml file to False.
{{ config(enabled=var('salesforce__user_enabled', True)) }}

with source as (

    select * from {{ source('salesforce', 'user') }}

),

renamed as (
    select

    {{
        fivetran_utils.fill_staging_columns(
            source_columns=adapter.get_columns_in_relation(source('salesforce', 'user')),
            staging_columns = get_salesforce_user_columns()
        )
    }}

        --The below script allows for pass through columns.
        {% if var('user_pass_through_columns',[]) != [] %},
        {{ var('user_pass_through_columns') | join (", ") }}
    {% endif %}

    from source
),

final as (

    select
        -- PK
        user_id,
        -- FK
        user_role_id,
        individual_id,
        manager_id,
        account_id,
        profile_id,
        contact_id,
        -- attributes
        state,
        city,
        street,
        postal_code,
        country,
        department,
        user_type,
        alias,
        user_name,
        company_name,
        trim(lower(user_email)) as user_email,
        last_name,
        username,
        is_active,
        first_name,
        user_title,
        created_at,
        updated_at,
        user_phone_number,

        -- dates
        cast(last_referenced_date as {{ dbt_utils.type_timestamp() }}) as last_referenced_date,
        cast(last_viewed_date as {{ dbt_utils.type_timestamp() }}) as last_viewed_date,
        cast(_fivetran_synced as {{ dbt_utils.type_timestamp() }}) as _fivetran_synced,
        cast(last_login_date as {{ dbt_utils.type_timestamp() }}) as last_login_date

        --The below script allows for pass through columns.
        {% if var('user_pass_through_columns',[]) != [] %},
            {{ var('user_pass_through_columns') | join (", ") }}
        {% endif %}

    from renamed

)

select * from final
