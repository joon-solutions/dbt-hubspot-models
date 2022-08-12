with source as (

    select * from {{ source('google_ads', 'account_history') }}

),

renamed as (

    select

        id as account_id,
        updated_at,
        _fivetran_synced,
        auto_tagging_enabled,
        currency_code,
        descriptive_name as account_name,
        final_url_suffix,
        hidden,
        manager,
        manager_customer_id,
        optimization_score,
        pay_per_conversion_eligibility_failure_reasons,
        test_account,
        time_zone,
        tracking_url_template,
        row_number() over (partition by account_id order by updated_at desc) = 1 as is_most_recent_record,
        {{ dbt_utils.surrogate_key(['account_id','_fivetran_synced']) }} as unique_id

    from source

)

select * from renamed
