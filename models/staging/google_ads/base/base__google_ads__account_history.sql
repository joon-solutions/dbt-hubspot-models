{{ config(enabled=var('ad_reporting__google_ads_enabled', False)) }}
with source as (

    select * from {{ source('google_ads', 'account_history') }}

),

renamed as (

    select
        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('google_ads', 'account_history')),
                staging_columns=get_google_ads_account_history_columns()
            )
        }}

    from source
),

final as (

    select

        account_id,
        updated_at,
        _fivetran_synced,
        auto_tagging_enabled,
        currency_code,
        account_name,
        row_number() over (partition by account_id order by updated_at desc) = 1 as is_most_recent_record,
        {{ dbt_utils.surrogate_key(['account_id','_fivetran_synced']) }} as unique_id

    from renamed

)

select * from final
