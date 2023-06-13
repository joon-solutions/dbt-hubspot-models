{{ config(enabled=var('ad_reporting__pinterest_enabled', False)) }}
with source as (

    select * from {{ source('pinterest_ads', 'pin_promotion_history') }}

),

renamed as (

    select
        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('pinterest_ads', 'pin_promotion_history')),
                staging_columns = get_pinterest_ads_pin_promotion_history_columns()
            )
        }}

        -- id as pin_promotion_id,
        -- ad_group_id,
        -- created_time,
        -- destination_url,
        -- name,
        -- pin_id,
        -- status,
        -- creative_type,
        -- _fivetran_synced,

    from source

),

final as (
    select
        *,
            {{ dbt_utils.split_part('destination_url', "'?'", 1) }} as base_url,
            {{ dbt_utils.get_url_host('destination_url') }} as url_host,
        '/' || {{ dbt_utils.get_url_path('destination_url') }} as url_path,
        {{ dbt_utils.get_url_parameter('destination_url', 'utm_source') }} as utm_source,
        {{ dbt_utils.get_url_parameter('destination_url', 'utm_medium') }} as utm_medium,
        {{ dbt_utils.get_url_parameter('destination_url', 'utm_campaign') }} as utm_campaign,
        {{ dbt_utils.get_url_parameter('destination_url', 'utm_content') }} as utm_content,
        {{ dbt_utils.get_url_parameter('destination_url', 'utm_term') }} as utm_term,
        {{ dbt_utils.surrogate_key(['pin_promotion_id','_fivetran_synced'] ) }} as version_id,
        row_number() over (partition by pin_promotion_id order by _fivetran_synced desc) as is_latest_version
    from renamed
)

select * from final
