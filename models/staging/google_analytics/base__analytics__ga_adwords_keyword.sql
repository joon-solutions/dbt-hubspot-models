{{ config(enabled = var('ga_adwords_keyword_enabled') ) }}

with source as (

    select * from {{ source('google_analytics', 'ga_adwords_keyword') }}

),

renamed as (

    select
        {{ dbt_utils.surrogate_key(['date','keyword', '_fivetran_id']) }} as id,
        date,
        keyword,
        _fivetran_id,
        ad_clicks,
        ad_cost,
        cpc,
        users,
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
