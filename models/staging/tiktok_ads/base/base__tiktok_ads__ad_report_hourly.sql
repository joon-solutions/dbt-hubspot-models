{{ config(enabled=var('ad_reporting__tiktok_ads_enabled')) }}

with source as (

    select * from {{ source('tiktok_ads', 'ad_report_hourly') }}

),

renamed as (

    select
        ad_id,
        stat_time_hour,
        cost_per_conversion,
        real_time_conversion,
        cpc,
        video_play_actions,
        conversion_rate,
        video_views_p_75,
        result,
        video_views_p_50,
        impressions,
        comments,
        real_time_cost_per_result,
        conversion,
        real_time_result,
        video_views_p_100,
        shares,
        real_time_conversion_rate,
        cost_per_secondary_goal_result,
        secondary_goal_result_rate,
        clicks,
        cost_per_1000_reached,
        video_views_p_25,
        reach,
        real_time_cost_per_conversion,
        profile_visits_rate,
        average_video_play,
        profile_visits,
        cpm,
        ctr,
        video_watched_2_s,
        follows,
        result_rate,
        video_watched_6_s,
        secondary_goal_result,
        cost_per_result,
        average_video_play_per_user,
        real_time_result_rate,
        spend,
        likes,
        _fivetran_synced

    from source

)

select * from renamed