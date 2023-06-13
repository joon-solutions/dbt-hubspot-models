{{ config(enabled=var('ad_reporting__linkedin_ads_enabled', False)) }}
with source as (

    select * from {{ source('linkedin_ads', 'ad_analytics_by_creative') }}

),

renamed as (
    select

        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('linkedin_ads', 'ad_analytics_by_creative')),
                staging_columns=get_linkedin_ads_ad_analytics_by_creative_columns()
            )
        }}
    from source
),


final as (

    select
        creative_id,
        cast(date_day as date) as date_day,
        clicks,
        impressions,
        {% if var('linkedin__use_local_currency') %}
            cost_in_local_currency as cost,
        {% else %}
            cost_in_usd as cost,
        {% endif %}
        --- passthrough metrics
        {% if var('linkedin__passthrough_metrics') %}
        , {{ var('linkedin__passthrough_metrics' )  | join(', ') }}
        {% endif %}
        {{ dbt_utils.surrogate_key(['date_day','creative_id']) }} as daily_creative_id

    from renamed

)

select * from final
