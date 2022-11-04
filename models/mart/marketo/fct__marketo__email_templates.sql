with latest_email_templates as (

    select *
    from {{ ref('base__marketo__email_template_history') }}
    where is_most_recent_version = true

),

email_sends as (

    select *
    from {{ ref('stg__marketo__email_sends') }}

),

abs_metrics as ( --PK=email_template_id
    select
        latest_email_templates.*,
        count(*) as count_sends,
        coalesce(sum(email_sends.count_opens), 0) as count_opens,
        coalesce(sum(email_sends.count_bounces), 0) as count_bounces,
        coalesce(sum(email_sends.count_clicks), 0) as count_clicks,
        coalesce(sum(email_sends.count_deliveries), 0) as count_deliveries,
        coalesce(sum(email_sends.count_unsubscribes), 0) as count_unsubscribes,
        count(distinct case when email_sends.was_opened = true then email_sends.email_send_id end) as count_unique_opens,
        count(distinct case when email_sends.was_clicked = true then email_sends.email_send_id end) as count_unique_clicks
    from latest_email_templates
    left join email_sends ---one-to-many (time condition turns PK of email_templates = email_template_id)
        on latest_email_templates.email_template_id = email_sends.email_template_id
            and email_sends.activity_timestamp
            between latest_email_templates.valid_from
            and coalesce(latest_email_templates.valid_to, cast('2099-01-01' as timestamp))
    {{ dbt_utils.group_by(29) }}

),

rates_metrics as (
    select
        *,
        div0(count_unique_opens, count_sends) as open_rates_by_sends,
        div0(count_unique_clicks, count_sends) as click_rates_by_sends,
        div0(count_unique_opens, count_deliveries) as open_rates_by_deliveries,
        div0(count_unique_clicks, count_deliveries) as click_rates_by_deliveries
    from abs_metrics
)

select *
from rates_metrics
