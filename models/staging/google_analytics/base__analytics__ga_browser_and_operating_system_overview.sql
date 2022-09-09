
{{ config(enabled = var('ga_browser_and_operating_system_overview_enabled') ) }}

with source as (

    select * from {{ source('google_analytics', 'ga_browser_and_operating_system_overview') }}

),

renamed as (

    select

        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('google_analytics', 'ga_browser_and_operating_system_overview')),
                staging_columns = get_google_analytics_ga_browser_and_operating_system_overview_columns()
            )
        }}

        -- date,
        -- _fivetran_id,
        -- operating_system,
        -- browser,
        -- users,
        -- new_users,
        -- sessions,
        -- bounce_rate,
        -- page_views_per_session,
        -- avg_session_duration,
        -- goal_conversion_rate_all,
        -- goal_completions_all,
        -- goal_value_all,
        -- _fivetran_synced

    from source

)

select
    *,
    {{ dbt_utils.surrogate_key(['date','_fivetran_id','operating_system','browser']) }} as id
from renamed
