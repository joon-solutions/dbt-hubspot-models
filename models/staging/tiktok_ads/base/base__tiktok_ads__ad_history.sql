{{ config(enabled=var('ad_reporting__tiktok_ads_enabled', False)) }}

with base as (

    select *
    from {{ source('tiktok_ads', 'ad_history') }}

),

fields as (

    select
        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('tiktok_ads', 'ad_history')),
                staging_columns=get_tiktok_ads_history_columns()
            )
        }}

    from base

),

final as (

    select
        ad_id,
        updated_at,
        ad_group_id,
        advertiser_id,
        campaign_id,
        ad_name,
        ad_text,
        call_to_action,
        click_tracking_url,
        impression_tracking_url,
        {{ dbt_utils.split_part('landing_page_url', "'?'", 1) }} as base_url,
        {{ dbt_utils.get_url_host('landing_page_url') }} as url_host,
        '/' || {{ dbt_utils.get_url_path('landing_page_url') }} as url_path,
        {{ dbt_utils.get_url_parameter('landing_page_url', 'utm_source') }} as utm_source,
        {{ dbt_utils.get_url_parameter('landing_page_url', 'utm_medium') }} as utm_medium,
        {{ dbt_utils.get_url_parameter('landing_page_url', 'utm_campaign') }} as utm_campaign,
        {{ dbt_utils.get_url_parameter('landing_page_url', 'utm_content') }} as utm_content,
        {{ dbt_utils.get_url_parameter('landing_page_url', 'utm_term') }} as utm_term,
        landing_page_url,
        video_id,
        _fivetran_synced
    from fields

),

most_recent as (

    select
        *,
        row_number() over (partition by ad_id order by updated_at desc) = 1 as is_most_recent_record,
        {{ dbt_utils.surrogate_key(['ad_id','updated_at']) }} as unique_id
    from final

)

select * from most_recent
