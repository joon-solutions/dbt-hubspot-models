{{ config(enabled = var('ga_events_overview_enabled') ) }}

with source as (

    select * from {{ source('google_analytics', 'ga_events_overview') }}

),

renamed as (

    select
        {{ dbt_utils.surrogate_key(['date','profile','_fivetran_id']) }} as id,
        date,
        profile,
        _fivetran_id,
        event_category,
        event_value,
        total_events,
        sessions_with_event,
        events_per_session_with_event,
        avg_event_value,
        unique_events,
        _fivetran_synced

    from source

)

select * from renamed
