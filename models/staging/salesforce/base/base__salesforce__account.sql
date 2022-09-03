with source as (

    select * from {{ source('salesforce', 'account') }}

),

renamed as (

    select
        id as account_id,
        account_source,
        name as account_name,
        cast(_fivetran_synced as {{ dbt_utils.type_timestamp() }}) as _fivetran_synced,
        description as account_description,
        cast(last_activity_date as {{ dbt_utils.type_timestamp() }}) as last_activity_date,
        cast(last_viewed_date as {{ dbt_utils.type_timestamp() }}) as last_viewed_date,
        type as account_type,
        billing_city,
        billing_street,
        billing_country,
        billing_postal_code,
        is_deleted,
        cast(last_referenced_date as {{ dbt_utils.type_timestamp() }}) as last_referenced_date,
        number_of_employees,
        industry

        --The below script allows for pass through columns.
        {% if var('account_pass_through_columns',[]) != [] %}
        , {{ var('account_pass_through_columns') | join (", ") }}

        {% endif %}

    from source

)

select * from renamed
