with source as (

    select * from {{ source('snapchat_ads', 'ad_hourly_report') }}

),

renamed as (

    select
        ad_id,
        date as date_hour,
        impressions,
        (spend / 1000000.0) as spend,
        swipes

    from source

)

select * from renamed