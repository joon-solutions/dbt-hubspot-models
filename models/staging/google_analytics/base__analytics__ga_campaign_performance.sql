{{ config(enabled = var('ga_campaign_performance_enabled') ) }}

with source as (

    select * from {{ source('google_analytics', 'ga_campaign_performance') }}

),

renamed as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('google_analytics', 'ga_campaign_performance')),
                staging_columns = get_google_analytics_ga_campaign_performance_columns()
            )
        }}

        -- date,
        -- campaign,
        -- _fivetran_id,
        -- users,
        -- new_users,
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
    {{ dbt_utils.surrogate_key(['date','_fivetran_id']) }} as id
from renamed
