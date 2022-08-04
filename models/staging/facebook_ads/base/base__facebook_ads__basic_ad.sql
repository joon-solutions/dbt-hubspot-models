with source as (

    select * from {{ source('facebook_ads', 'basic_ad') }}

),

renamed as (

    select
        ad_id,
        date as date_day,
        account_id,
        impressions,
        inline_link_clicks as clicks,
        spend

    from source

)

select * from renamed