{{ config(enabled=var('ad_reporting__google_ads_enabled')) }}
with source as (

    select * from {{ source('google_ads', 'ad_stats') }}

),

renamed as (

    select
        _fivetran_id,
        customer_id as account_id,
        date as date_day,
        ad_group as ad_group_id,
        ad_id,
        _fivetran_synced,
        active_view_impressions,
        active_view_measurability,
        active_view_measurable_cost_micros,
        active_view_measurable_impressions,
        active_view_viewability,
        ad_group_base_ad_group,
        ad_network_type,
        campaign_base_campaign,
        campaign_id,
        clicks,
        conversions,
        conversions_value,
        device,
        impressions,
        interaction_event_types,
        interactions,
        keyword_ad_group_criterion,
        view_through_conversions,
        cost_micros / 1000000.0 as spend,
        {{ dbt_utils.surrogate_key(['date_day','ad_group_id', 'campaign_id', 'account_id']) }} as unique_id

    from source

)

select * from renamed
