{{ config(enabled = var('hubspot__deal', False) and var('hubspot__owner', False) ) }}

with deals_enhanced as (

    select *
    from {{ ref('int_hubspot__deals_enhanced') }}

    {% if fivetran_utils.enabled_vars(['hubspot_engagement_enabled','hubspot_engagement_deal_enabled']) %}

),

    engagements as (

        select *
        from {{ ref('base__hubspot__engagement') }}

),

    engagement_deals as (

        select *
        from {{ ref('base__hubspot__engagement_deal') }}

),

    engagement_deal_joined as (

        select
            engagements.engagement_type,
            engagement_deals.deal_id
        from engagements
        inner join engagement_deals
            on engagements.engagement_id = engagement_deals.engagement_id

),

    engagement_deal_agg as (

    {{ hubspot_engagements_agg('engagement_deal_joined', 'deal_id') }}

),

    engagements_joined as (
        select
            deals_enhanced.*,
            {% for metric in engagement_metrics() %}
                coalesce(engagement_deal_agg.{{ metric }}, 0) as {{ metric }} {% if not loop.last %},{% endif %}
            {% endfor %}
        from deals_enhanced
        left join engagement_deal_agg on deals_enhanced.deal_id = engagement_deal_agg.deal_id
)

    select *
    from engagements_joined

    {% else %}

select *
from deals_enhanced

{% endif %}
