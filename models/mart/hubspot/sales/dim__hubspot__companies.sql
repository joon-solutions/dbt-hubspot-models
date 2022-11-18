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

engagement_companies_agg as (

    select
        engagement_companies.company_id,
        count(case when engagements.engagement_type = 'NOTE' then 1 end) as count_engagement_notes,
        count(case when engagements.engagement_type = 'TASK' then 1 end) as count_engagement_tasks,
        count(case when engagements.engagement_type = 'CALL' then 1 end) as count_engagement_calls,
        count(case when engagements.engagement_type = 'MEETING' then 1 end) as count_engagement_meetings,
        count(case when engagements.engagement_type = 'EMAIL' then 1 end) as count_engagement_emails,
        count(case when engagements.engagement_type = 'INCOMING_EMAIL' then 1 end) as count_engagement_incoming_emails,
        count(case when engagements.engagement_type = 'FORWARDED_EMAIL' then 1 end) as count_engagement_forwarded_emails
    from engagements
    inner join engagement_companies on engagements.engagement_id = engagement_companies.engagement_id
    group by 1

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
