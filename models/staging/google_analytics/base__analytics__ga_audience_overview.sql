{{ config(enabled = var('ga_audience_overview_enabled', False) ) }}

with source as (

    select * from {{ source('google_analytics', 'ga_audience_overview') }}

),

renamed as (

    select
         {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('google_analytics', 'ga_audience_overview')),
                staging_columns = get_google_analytics_ga_audience_overview_columns()
            )
        }}

        -- date,
        -- _fivetran_id,
        -- users,
        -- new_users,
        -- sessions,
        -- sessions_per_user,
        -- page_views,
        -- page_views_per_session,
        -- avg_session_duration,
        -- bounce_rate,
        -- _fivetran_synced

    from source

)

select
    *,
    {{ dbt_utils.surrogate_key(['date','_fivetran_id']) }} as id
from renamed
