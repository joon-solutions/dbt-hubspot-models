with source as (

    select * from {{ source('snapchat_ads', 'ad_hourly_report') }}

),

renamed as (

    select
        ad_id,
        date as date_hour,
        impressions,
        (spend / 1000000.0) as spend,
        swipes,
        {{ dbt_utils.surrogate_key(['ad_id','date_hour']) }} as unique_id

    from source

)

select * from renamed