{{ config(enabled = var('ga_traffic_enabled', False) ) }}

with source as (

    select * from {{ source('google_analytics', 'ga_traffic') }}

),

renamed as (

    select
        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('google_analytics', 'ga_traffic')),
                staging_columns = get_google_analytics_ga_traffic_columns()
            )
        }}
        -- date,
        -- page_title,
        -- _fivetran_id,
        -- users,
        -- page_value,
        -- entrances,
        -- page_views,
        -- unique_page_views,
        -- avg_time_on_page,
        -- percent_exit,
        -- bounce_rate,
        -- _fivetran_synced

    from source

)

select
    *,
    {{ dbt_utils.surrogate_key(['date','_fivetran_id']) }} as id

from renamed
