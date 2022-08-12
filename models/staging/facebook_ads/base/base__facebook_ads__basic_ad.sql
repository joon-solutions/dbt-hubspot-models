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
        spend,
        {{ dbt_utils.surrogate_key(['ad_id','account_id','date_day']) }} as unique_id

    from source

)

select * from renamed
