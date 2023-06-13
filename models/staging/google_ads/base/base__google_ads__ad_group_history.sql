{{ config(enabled=var('ad_reporting__google_ads_enabled', False)) }}
with source as (

    select * from {{ source('google_ads', 'ad_group_history') }}

),

renamed as (

    select
        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('google_ads', 'ad_group_history')),
                staging_columns=get_google_ads_ad_group_history_columns()
            )
        }}

    from source
),

final as (

    select

        ad_group_id,
        updated_at,
        _fivetran_synced,
        ad_group_type,
        campaign_id,
        campaign_name,
        ad_group_name,
        ad_group_status,
        row_number() over (partition by ad_group_id order by updated_at desc) = 1 as is_most_recent_record,
        {{ dbt_utils.surrogate_key(['ad_group_id','_fivetran_synced']) }} as unique_id

    from renamed

)

select * from final
