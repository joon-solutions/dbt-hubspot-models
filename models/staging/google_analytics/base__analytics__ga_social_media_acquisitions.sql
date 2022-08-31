{{ config(enabled = var('ga_social_media_acquisitions_enabled') ) }}

with source as (

    select * from {{ source('google_analytics', 'ga_social_media_acquisitions') }}

),

renamed as (

    select
        {{ dbt_utils.surrogate_key(['date','_fivetran_id']) }} as id,
        date,
        social_network,
        _fivetran_id,
        sessions,
        percent_new_sessions,
        new_users,
        bounce_rate,
        page_views,
        page_views_per_session,
        avg_session_duration,
        transactions_per_session,
        transaction_revenue,
        _fivetran_synced

    from source

)

select * from renamed
