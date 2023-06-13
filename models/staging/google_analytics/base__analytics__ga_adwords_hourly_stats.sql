{{ config(enabled = var('ga_adwords_hourly_stats_enabled', False) ) }}

with source as (

    select * from {{ source('google_analytics', 'ga_adwords_hourly_stats') }}

),

renamed as (

    select
        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('google_analytics', 'ga_adwords_hourly_stats')),
                staging_columns = get_google_analytics_ga_adwords_hourly_stats_columns()
            )
        }}

        -- date,
        -- datehour,
        -- right(datehour, 2) as hour,
        -- _fivetran_id,
        -- ad_clicks,
        -- ad_cost,
        -- cpc,
        -- users,
        -- sessions,
        -- bounce_rate,
        -- page_views_per_session,
        -- goal_conversion_rate_all,
        -- goal_completions_all,
        -- goal_value_all,
        -- _fivetran_synced

    from source

)

select
    *,
    right(datehour, 2) as hour,
    {{ dbt_utils.surrogate_key(['date','datehour', '_fivetran_id']) }} as id

from renamed
