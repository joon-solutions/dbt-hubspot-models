{{ config(enabled = var('hubspot__company', False) ) }}

with companies_base as (

    select *
    from {{ ref('base__hubspot__company') }}

),

companies as (
    select 
            *,
            case    when lifecycle_stage = 'subscriber' then 1
                    when lifecycle_stage = 'lead' then 2
                    when lifecycle_stage = 'marketingqualifiedlead' then 3
                    when lifecycle_stage = 'salesqualifiedlead' then 4
                    when lifecycle_stage = 'opportunity' then 5
                    when lifecycle_stage = 'customer' then 6
                    when lifecycle_stage = 'evangelist' then 7
                    when lifecycle_stage = 'other' then 9
            end as lifecycle_stage_num,
            case    when lifecycle_stage = 'subscriber' then avg(time_in_subscriber) over ()
                    when lifecycle_stage = 'lead' then avg(time_in_lead) over ()
                    when lifecycle_stage = 'marketingqualifiedlead' then avg(time_in_marketingqualifiedlead) over ()
                    when lifecycle_stage = 'salesqualifiedlead' then avg(time_in_salesqualifiedlead) over ()
                    when lifecycle_stage = 'opportunity' then avg(time_in_opportunity) over ()
                    when lifecycle_stage = 'customer' then avg(time_in_customer) over ()
                    when lifecycle_stage = 'evangelist' then avg(time_in_evangelist) over ()
                    else null
            end as time_in_stage

    from companies_base
),

{% if fivetran_utils.enabled_vars(vars=["hubspot__engagement", "hubspot__engagement_company"]) %}

    engagements as (

        select *
        from {{ ref('base__hubspot__engagement') }}

    ),

    engagement_companies as (

        select *
        from {{ ref ('base__hubspot__engagement_company') }}

    ),

    engagement_companies_joined as (

        select
            engagements.engagement_type,
            engagement_companies.company_id
        from engagements
        inner join engagement_companies on engagements.engagement_id = engagement_companies.engagement_id

    ),

    engagement_companies_agg as (

    {{ hubspot_engagements_agg('engagement_companies_joined', 'company_id') }}

    ),

    joined as (

        select
            companies.*,
            -- engagement_companies_agg.count_engagement,
            {% for metric in engagement_metrics() %}
                coalesce(engagement_companies_agg.{{ metric }}, 0) as {{ metric }} {% if not loop.last %},{% endif %}
            {% endfor %}
        from companies
        left join engagement_companies_agg on companies.company_id = engagement_companies_agg.company_id

    )

    select *
    from joined

{% else %}

select *
from companies

{% endif %}



