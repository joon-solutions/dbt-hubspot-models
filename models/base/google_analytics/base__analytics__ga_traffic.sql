with source as (

    select * from {{ source('google_analytics', 'ga_traffic') }}

),

renamed as (

    select
        {{ dbt_utils.surrogate_key(['date','_fivetran_id']) }} as id,
        date,
        page_title,
        _fivetran_id,
        users,
        page_value,
        entrances,
        page_views,
        unique_page_views,
        avg_time_on_page,
        percent_exit,
        bounce_rate,
        _fivetran_synced

    from source

)

select * from renamed

