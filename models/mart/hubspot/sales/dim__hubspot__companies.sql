{{ config(enabled = var('hubspot__company') ) }}

with companies as (

    select *
    from {{ ref('base__hubspot__company') }}

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
