{{ config(enabled = var('ga_channel_traffic_enabled') ) }}

with source as (

    select * from {{ source('google_analytics', 'ga_channel_traffic') }}

),

renamed as (

    select
        {{ dbt_utils.surrogate_key(['date','profile', '_fivetran_id']) }} as id,
        date,
        profile,
        _fivetran_id,
        channel_grouping,
        goal_value_all,
        new_users,
        sessions,
        avg_session_duration,
        goal_completions_all,
        page_views_per_session,
        goal_conversion_rate_all,
        users,
        bounce_rate,
        percent_new_sessions,
        _fivetran_synced

    from source

)

select * from renamed
