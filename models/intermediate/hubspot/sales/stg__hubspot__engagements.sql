{{ config(enabled = var('hubspot__engagement') ) }}

with engagements as (

    select *
    from {{ ref('base__hubspot__engagement') }}

),

{% if var('hubspot__engagement_contact', True) %}

    contacts_agg as (

        select
            engagement_id,
            array_agg(contact_id) as contact_ids
        from {{ ref('base__hubspot__engagement_contact') }}
        group by 1

    ),

{% endif %}

{% if var('hubspot__deal', True) %}

    deals_agg as (

        select
            engagement_id,
            array_agg(deal_id) as deal_ids
        from {{ ref('base__hubspot__engagement_deal') }}
        group by 1

    ),

{% endif %}

{% if var('hubspot__engagement_company', True) %}

    companies_agg as (

        select
            engagement_id,
            array_agg(company_id) as company_ids
        from {{ ref ('base__hubspot__engagement_company') }}
        group by 1

    ),

{% endif %}


joined as (

    select
        {% if var('hubspot__engagement_contact', True) %}
            contacts_agg.contact_ids,
        {% endif %}

                {% if var('hubspot__deal', True) %} 
            deals_agg.deal_ids,
        {% endif %}

        {% if var('hubspot__engagement_company', True) %}
            companies_agg.company_ids,
        {% endif %}

        engagements.*
    from engagements

        {% if var('hubspot__engagement_contact', True) %}
        left join contacts_agg on engagements.engagement_id = contacts_agg.engagement_id --many-to-one relationship
        {% endif %}

        {% if var('hubspot__deal', True) %}
            left join deals_agg on engagements.engagement_id = deals_agg.engagement_id --many-to-one relationship
        {% endif %}

        {% if var('hubspot__engagement_company', True) %}
            left join companies_agg on engagements.engagement_id = companies_agg.engagement_id --many-to-one relationship
        {% endif %}

)

select *
from joined
