with source as (

    select * from {{ source('pinterest_ads', 'pin_promotion_report') }}

),

renamed as (

    select
        date as date_day,
        pin_promotion_id,
        ad_group_id,
        campaign_id,
        advertiser_id,
        _fivetran_synced,
        coalesce(impression_1, 0) + coalesce(impression_2, 0) as impressions,
        coalesce(clickthrough_1, 0) + coalesce(clickthrough_2, 0) as clicks,
        spend_in_micro_dollar / 1000000.0 as spend,
        {{ dbt_utils.surrogate_key(['date_day','pin_promotion_id']) }} as report_id

    from source

)

select * from renamed
