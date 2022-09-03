with source as (

    select * from {{ source('salesforce', 'user') }}

),

renamed as (

    select
        -- PK
        id as user_id,
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
        name as user_name,
        company_name,
        email,
        last_name,
        username,
        is_active,
        first_name,
        title,

        -- dates
        cast(last_referenced_date as {{ dbt_utils.type_timestamp() }}) as last_referenced_date,
        cast(last_viewed_date as {{ dbt_utils.type_timestamp() }}) as last_viewed_date,
        cast(_fivetran_synced as {{ dbt_utils.type_timestamp() }}) as _fivetran_synced,
        cast(last_login_date as {{ dbt_utils.type_timestamp() }}) as last_login_date

        --The below script allows for pass through columns.
        {% if var('user_pass_through_columns',[]) != [] %}
        , {{ var('user_pass_through_columns') | join (", ") }}

        {% endif %}

    from source

)

select * from renamed
