{{ config(enabled=var('ad_reporting__tiktok_ads_enabled')) }}

with source as (

    select * from {{ source('tiktok_ads', 'adgroup_history') }}

),

final as (

    select
        adgroup_id as ad_group_id,
        updated_at,
        advertiser_id,
        campaign_id,
        action_days,
        action_categories,
        adgroup_name as ad_group_name,
        age,
        audience_type,
        budget,
        category,
        display_name,
        interest_category_v_2 as interest_category,
        frequency,
        frequency_schedule,
        gender,
        languages,
        landing_page_url,
        _fivetran_synced
    from source

),

most_recent as (

    select
        *,
        row_number() over (partition by ad_group_id order by updated_at desc) = 1 as is_most_recent_record,
        {{ dbt_utils.surrogate_key(['ad_group_id','_fivetran_synced']) }} as unique_id
    from final

)

select * from most_recent
