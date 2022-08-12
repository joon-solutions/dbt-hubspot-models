with source as (

    select * from {{ source('google_ads', 'ad_group_history') }}

),

renamed as (

    select
        
        id as ad_group_id,
        updated_at,
        ad_group_rotation_mode,
        type as ad_group_type,
        base_ad_group_id,
        base_campaign_id,
        bidding_strategy_bid_ceiling,
        bidding_strategy_bid_changes_for_raises_only,
        bidding_strategy_bid_floor,
        bidding_strategy_bid_modifier,
        bidding_strategy_competitor_domain,
        bidding_strategy_cpa_bid_amount,
        bidding_strategy_cpc_bid_amount,
        bidding_strategy_cpm_bid_amount,
        bidding_strategy_enhanced_cpc_enabled,
        bidding_strategy_id,
        bidding_strategy_max_cpc_bid_ceiling,
        bidding_strategy_max_cpc_bid_floor,
        bidding_strategy_name,
        bidding_strategy_raise_bid_when_budget_constrained,
        bidding_strategy_raise_bid_when_low_quality_score,
        bidding_strategy_scheme_type,
        bidding_strategy_source,
        bidding_strategy_spend_target,
        bidding_strategy_strategy_goal,
        bidding_strategy_target_cpa,
        bidding_strategy_target_outrank_share,
        bidding_strategy_target_roas,
        bidding_strategy_target_roas_override,
        bidding_strategy_type,
        bidding_strategy_viewable_cpm_enabled,
        campaign_id,
        content_bid_criterion_type_group,
        final_url_suffix,
        tracking_url_template,
        campaign_name,
        name as ad_group_name, 
        status as ad_group_status,
        _fivetran_synced,
        row_number() over (partition by ad_group_id order by updated_at desc) = 1 as is_most_recent_record,
        {{ dbt_utils.surrogate_key(['ad_group_id','_fivetran_synced']) }} as unique_id

    from source

)

select * from renamed