{{ config(enabled = var('ga_social_media_acquisitions_enabled', False) ) }}

with source as (

    select * from {{ source('google_analytics', 'ga_social_media_acquisitions') }}

),

renamed as (

    select
        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('google_analytics', 'ga_social_media_acquisitions')),
                staging_columns = get_google_analytics_ga_social_media_acquisitions_columns()
            )
        }}

        -- date,
        -- social_network,
        -- _fivetran_id,
        -- sessions,
        -- percent_new_sessions,
        -- new_users,
        -- bounce_rate,
        -- page_views,
        -- page_views_per_session,
        -- avg_session_duration,
        -- transactions_per_session,
        -- transaction_revenue,
        -- _fivetran_synced

    from source

)

select
    *,
    {{ dbt_utils.surrogate_key(['date','_fivetran_id']) }} as id

from renamed
