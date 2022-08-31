{{ config(enabled = var('ga_campaign_performance_enabled') ) }}

with source as (

    select * from {{ source('google_analytics', 'ga_campaign_performance') }}

),

renamed as (

    select
        {{ dbt_utils.surrogate_key(['date','_fivetran_id']) }} as id,
        date,
        campaign,
        _fivetran_id,
        users,
        new_users,
        sessions,
        bounce_rate,
        page_views_per_session,
        goal_conversion_rate_all,
        goal_completions_all,
        goal_value_all,
        _fivetran_synced

    from source

)

select * from renamed
