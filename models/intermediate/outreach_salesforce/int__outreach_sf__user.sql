{{ config(enabled = var('outreach_user') ) }}
{{ config(enabled=var('salesforce__user_enabled')) }}

with outreach as (

    select
        *,
        'outreach' as source
    from {{ ref('base__outreach__users') }}
),

sf as (
    select
        *,
        'sf' as source
    from {{ ref('base__salesforce__user') }}
),

final as (
    select
        outreach.user_id as outreach_user_id,
        sf.user_id as sf_user_id,
        coalesce(outreach.user_name, sf.user_name) as user_name,
        coalesce(outreach.user_email, sf.user_email) as user_email,
        coalesce(outreach.user_title, sf.user_title) as user_title,
        coalesce(outreach.user_phone_number, sf.user_phone_number) as user_phone_number,
        coalesce(outreach.created_at, sf.created_at) as created_at,
        coalesce(outreach.updated_at, sf.updated_at) as updated_at,
        coalesce(outreach.source, sf.source) as source,
        {{ dbt_utils.surrogate_key(['outreach.user_id', 'sf.user_id']) }} as user_id

    from outreach
    full outer join sf on outreach.user_email = sf.user_email
)

select *
from final
