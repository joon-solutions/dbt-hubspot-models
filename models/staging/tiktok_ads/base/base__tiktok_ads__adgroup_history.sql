{{ config(enabled=var('ad_reporting__tiktok_ads_enabled')) }}

with source as (

    select * from {{ source('tiktok_ads', 'adgroup_history') }}

),

final as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('tiktok_ads', 'adgroup_history')),
                staging_columns=get_tiktok_ads_adgroup_history_columns()
            )
        }}
    from source

),

most_recent as (

    select
        *,
        row_number() over (partition by ad_group_id order by updated_at desc) = 1 as is_most_recent_record,
        {{ dbt_utils.surrogate_key(['ad_group_id','_fivetran_synced']) }} as unique_id
    from final

)

select * from most_recent
