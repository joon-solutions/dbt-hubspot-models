{{ config(enabled=var('ad_reporting__pinterest_enabled')) }}
with source as (

    select * from {{ source('pinterest_ads', 'pin_promotion_report') }}

),

renamed as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('pinterest_ads', 'pin_promotion_report')),
                staging_columns = get_pinterest_ads_pin_promotion_report_columns()
            )
        }}
        -- date as date_day,
        -- pin_promotion_id,
        -- ad_group_id,
        -- campaign_id,
        -- advertiser_id,
        -- _fivetran_synced,

        
    from source

)

select *,
        cast(date as date) as date_day,
        {% for metric in var('pin_promotion_report_pass_through_metric') %}
            {{ metric }},
        {% endfor %}
        coalesce(impression_1, 0) + coalesce(impression_2, 0) as impressions,
        coalesce(clickthrough_1, 0) + coalesce(clickthrough_2, 0) as clicks,
        spend_in_micro_dollar / 1000000.0 as spend,
        {{ dbt_utils.surrogate_key(['date_day','pin_promotion_id']) }} as report_id 
from renamed
