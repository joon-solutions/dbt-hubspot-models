{{ config(enabled=var('ad_reporting__twitter_ads_enabled')) }}
with source as (

    select * from {{ source('twitter_ads', 'campaign_history') }}

),

renamed as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('twitter_ads', 'campaign_history')),
                staging_columns=get_campaign_history_columns()
            )
        }}
    from source

)

select
    *,
    row_number() over (partition by campaign_id order by updated_timestamp asc) = 1 as is_latest_version,
    {{ dbt_utils.surrogate_key(['campaign_id','updated_timestamp']) }} as unique_id
from renamed