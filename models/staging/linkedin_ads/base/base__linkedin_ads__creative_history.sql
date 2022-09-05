{{ config(enabled=var('ad_reporting__linkedin_ads_enabled')) }}
with source as (

    select * from {{ source('linkedin_ads', 'creative_history') }}

),

renamed as (

    select
        id as creative_id,
        cast(last_modified_time as {{ dbt_utils.type_timestamp() }}) as last_modified_at,
        cast(created_time as {{ dbt_utils.type_timestamp() }}) as created_at,
        campaign_id,
        type as creative_type,
        cast(version_tag as numeric) as version_tag,
        status as creative_status,
        click_uri
    from source

),

url_fields as (

    select
        *,
        {{ dbt_utils.split_part('click_uri', "'?'", 1) }} as base_url,
        {{ dbt_utils.get_url_host('click_uri') }} as url_host,
        '/' || {{ dbt_utils.get_url_path('click_uri') }} as url_path,
        {{ dbt_utils.get_url_parameter('click_uri', 'utm_source') }} as utm_source,
        {{ dbt_utils.get_url_parameter('click_uri', 'utm_medium') }} as utm_medium,
        {{ dbt_utils.get_url_parameter('click_uri', 'utm_campaign') }} as utm_campaign,
        {{ dbt_utils.get_url_parameter('click_uri', 'utm_content') }} as utm_content,
        {{ dbt_utils.get_url_parameter('click_uri', 'utm_term') }} as utm_term
    from renamed

),

valid_dates as (

    select
        *,
        case
            when row_number() over (partition by creative_id order by version_tag) = 1 then created_at
            else last_modified_at
        end as valid_from,
        lead(last_modified_at) over (partition by creative_id order by version_tag) as valid_to
    from url_fields

),

surrogate_key as (

    select
        *,
        {{ dbt_utils.surrogate_key(['creative_id','version_tag']) }} as creative_version_id
    from valid_dates

)

select *
from surrogate_key