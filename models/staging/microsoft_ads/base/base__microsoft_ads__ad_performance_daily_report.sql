with source as (

    select * from {{ source('microsoft_ads', 'ad_performance_daily_report') }}

),

renamed as (

    select
        date as date_day,
        account_id,
        campaign_id,
        ad_group_id,
        ad_id,
        currency_code,
        clicks,
        impressions,
        spend

    from source

)

select * from renamed