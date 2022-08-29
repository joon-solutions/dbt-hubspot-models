
with source as (

   select * from {{ source('salesforce', 'user') }}

),

renamed as (

    select
         _fivetran_deleted,
        cast(_fivetran_synced as {{ dbt_utils.type_timestamp() }}) as _fivetran_synced,
        account_id,
        alias,
        city,
        company_name,
        contact_id,
        country,
        country_code,
        department,
        email,
        first_name,
        id as user_id,
        individual_id,
        is_active,
        cast(last_login_date as {{ dbt_utils.type_timestamp() }}) as last_login_date,
        last_name,
        cast(last_referenced_date as {{ dbt_utils.type_timestamp() }}) as last_referenced_date,
        cast(last_viewed_date as {{ dbt_utils.type_timestamp() }}) as last_viewed_date,
        manager_id,
        name as user_name,
        postal_code,
        profile_id,
        state,
        state_code,
        street,
        title,
        user_role_id,
        user_type,
        username 
        
        --The below script allows for pass through columns.
        {% if var('user_pass_through_columns',[]) != [] %}
        , {{ var('user_pass_through_columns') | join (", ")}}

        {% endif %}

    from source

)

select * from renamed
