{{ config(enabled=var('ad_reporting__tiktok_ads_enabled')) }}

with source as (

    select * from {{ source('tiktok_ads', 'campaign_history') }}

),

final as (

    select
        campaign_id,
        updated_at,
        advertiser_id,
        campaign_name,
        campaign_type,
        split_test_variable,
        _fivetran_synced

    from source

),

most_recent as (

    select
        *,
        row_number() over (partition by campaign_id order by updated_at desc) = 1 as is_most_recent_record,
        {{ dbt_utils.surrogate_key(['campaign_id','updated_at']) }} as unique_id
    from final

)

select * from most_recent
