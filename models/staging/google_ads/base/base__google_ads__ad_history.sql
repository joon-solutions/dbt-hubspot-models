{{ config(enabled=var('ad_reporting__google_ads_enabled', False)) }}
with source as (

    select * from {{ source('google_ads', 'ad_history') }}

),

renamed as (

    select
        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('google_ads', 'ad_history')),
                staging_columns=get_google_ads_ad_history_columns()
            )
        }}

    from source
),

final as (

    select
        ad_group_id,
        ad_id,
        updated_at,
        _fivetran_synced,
        ad_type,
        ad_status,
        source_final_urls,
        replace(replace(source_final_urls, '[', ''), ']', '') as final_urls
    from renamed
),

most_recent as (

    select
        ad_group_id,
        ad_id,
        updated_at,
        _fivetran_synced,
        ad_type,
        ad_status,
        source_final_urls,

        --Extract the first url within the list of urls provided within the final_urls field
        {{ dbt_utils.split_part(string_text='final_urls', delimiter_text="','", part_number=1) }} as final_url,

        row_number() over (partition by ad_id order by updated_at desc) = 1 as is_most_recent_record
    from final

),

url_fields as (
    select
        *,
        {{ dbt_utils.split_part('final_url', "'?'", 1) }} as base_url,
        {{ dbt_utils.get_url_host('final_url') }} as url_host,
        '/' || {{ dbt_utils.get_url_path('final_url') }} as url_path,
        {{ dbt_utils.get_url_parameter('final_url', 'utm_source') }} as utm_source,
        {{ dbt_utils.get_url_parameter('final_url', 'utm_medium') }} as utm_medium,
        {{ dbt_utils.get_url_parameter('final_url', 'utm_campaign') }} as utm_campaign,
        {{ dbt_utils.get_url_parameter('final_url', 'utm_content') }} as utm_content,
        {{ dbt_utils.get_url_parameter('final_url', 'utm_term') }} as utm_term,
        {{ dbt_utils.surrogate_key(['ad_id','_fivetran_synced']) }} as unique_id
    from most_recent
)

select *
from url_fields
