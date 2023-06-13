{{ config(enabled=var('ad_reporting__tiktok_ads_enabled', False)) }}

with source as (

    select * from {{ source('tiktok_ads', 'campaign_history') }}

),

final as (

    select
        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('tiktok_ads', 'campaign_history')),
                staging_columns=get_tiktok_ads_campaign_history_columns()
            )
        }}

    from source

),

most_recent as (

    select
        *,
        row_number() over (partition by campaign_id order by updated_at desc) = 1 as is_most_recent_record,
        {{ dbt_utils.surrogate_key(['campaign_id','updated_at']) }} as unique_id
    from final

)

select * from most_recent
