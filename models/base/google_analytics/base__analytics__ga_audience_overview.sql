{{ config(enabled = var('ga_audience_overview_enabled') ) }}

with source as (

    select * from {{ source('google_analytics', 'ga_audience_overview') }}

),

renamed as (

    select
        {{ dbt_utils.surrogate_key(['date','_fivetran_id']) }} as id,
        date,
        _fivetran_id,
        users,
        new_users,
        sessions,
        sessions_per_user,
        page_views,
        page_views_per_session,
        avg_session_duration,
        bounce_rate,
        _fivetran_synced

    from source

)

select * from renamed

