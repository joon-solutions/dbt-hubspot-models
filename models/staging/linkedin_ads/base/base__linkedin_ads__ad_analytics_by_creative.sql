{{ config(enabled=var('ad_reporting__linkedin_ads_enabled')) }}
with source as (

    select * from {{ source('linkedin_ads', 'ad_analytics_by_creative') }}

),

renamed as (

    select
        creative_id,
        cast(day as {{ dbt_utils.type_timestamp() }}) as date_day,
        clicks,
        impressions,
        {% if var('linkedin__use_local_currency') %}
        cost_in_local_currency as cost,
        {% else %}
        cost_in_usd as cost,
        {% endif %}
        {{ dbt_utils.surrogate_key(['date_day','creative_id']) }} as daily_creative_id

    from source

)

select * from renamed
