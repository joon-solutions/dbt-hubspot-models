{{ config(enabled=var('ad_reporting__google_ads_enabled')) }}
with source as (

    select * from {{ source('google_ads', 'campaign_history') }}

),

renamed as (

    select
        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('google_ads', 'campaign_history')),
                staging_columns=get_google_ads_campaign_history_columns()
            )
        }}

    from source
),

final as (

    select
        campaign_id,
        updated_at,
        _fivetran_synced,
        campaign_name,
        account_id,
        row_number() over (partition by campaign_id order by updated_at desc) = 1 as is_most_recent_record,
        {{ dbt_utils.surrogate_key(['campaign_id','_fivetran_synced']) }} as unique_id

    from renamed

)

select * from final
