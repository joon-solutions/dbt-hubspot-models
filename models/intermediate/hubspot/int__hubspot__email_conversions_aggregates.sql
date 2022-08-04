{{ config(enabled = var('contact_form_submission_enabled') ) }}

with contact_form_submission as (

    select *
    from {{ ref('base__hubspot__contact_form_submission') }}

),

aggregates as (

    select
        contact_id,
        count(distinct conversion_id) as conversions
    from contact_form_submission
    group by 1

)

select * from aggregates

