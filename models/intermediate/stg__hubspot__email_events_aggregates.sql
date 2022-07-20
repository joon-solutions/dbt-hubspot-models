{{ config(enabled = var('email_event_enabled') ) }}

{% set column_names = {
        'OPEN' : 'opens',
        'SENT' : 'sends',
        'DELIVERED' : 'deliveries',
        'DROPPED' : 'drops',
        'CLICK': 'clicks',
        'FORWARD': 'forwards',
        'DEFERRED': 'deferrals',
        'BOUNCE': 'bounces',
        'SPAMREPORT': 'spam_reports',
        'PRINT': 'prints'                         
}
%}

with events as (

    select *
    from {{ ref('base__hubspot__email_event') }}

),

aggregates as (

    select
        email_send_id, --PK
        email_campaign_id,
        email_send_at,
        recipient,
        {% for item in column_names %}
        count(case when event_type = '{{ item }}' then email_event_id end) as {{ column_names[item] }}{% if not loop.last %},{% endif %}
        {% endfor %}
    from events
    {{ dbt_utils.group_by(4) }}
)

select * from aggregates

