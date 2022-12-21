with sf as (
    select
        *,
        cast('sf' as {{ dbt_utils.type_string() }}) as source
    from {{ ref('base__salesforce__account') }}
),

outreach as (
    select
        *,
        cast('outreach' as {{ dbt_utils.type_string() }}) as source
    from {{ ref('base__outreach__account') }}
),


final as (
    select
        -- salesforce
        sf.account_id as sf_account_id,
        sf.account_name as sf_account_name,
        sf.last_activity_date,
        sf.last_viewed_date,
        sf.billing_city,
        sf.billing_street,
        sf.billing_country,
        sf.billing_postal_code,
        sf.last_referenced_date,
        sf.industry,
        -- outreach
        outreach.company_type,
        outreach.account_name as outreach_account_name,
        outreach.account_id as outreach_account_id,
        outreach.buyer_intent_score,
        outreach.account_created_at,
        outreach.website_url,
        outreach.domain,
        outreach.external_source,
        outreach.followers,
        coalesce(sf.number_of_employees, outreach.number_of_employees) as number_of_employees,
        coalesce(sf.source, outreach.source) as source,
        {{ dbt_utils.surrogate_key(['sf.account_id','outreach.account_id']) }} as id

    from sf
    -- full outer join outreach on lower(sf.account_name) = lower(outreach.account_name)
    full join outreach on lower(sf.account_name) = lower(outreach.account_name)
)

select * from final
