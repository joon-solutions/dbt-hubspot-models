{{ config(enabled=var('ad_reporting__google_ads_enabled')) }}
with source as (

    select * from {{ source('google_ads', 'ad_stats') }}

),

renamed as (

    select
        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('google_ads', 'ad_stats')),
                staging_columns=get_google_ads_ad_stats_columns()
            )
        }}

    from source
),

final as (

    select
        account_id,
        date_day,
        ad_group_id,
        ad_id,
        campaign_id,
        clicks,
        cost_micros / 1000000.0 as spend,
        impressions,
        {% for metric in var('google_ads__ad_stats_passthrough_metrics') %}
        , {{ metric }}
        {% endfor %}
        {{ dbt_utils.surrogate_key(['date_day','ad_group_id', 'campaign_id', 'account_id']) }} as unique_id

    from renamed

)

select * from final
