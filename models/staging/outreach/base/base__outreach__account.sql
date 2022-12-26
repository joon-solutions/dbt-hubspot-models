
{{ config(enabled = var('outreach_account') ) }}

with source as (

    select * from {{ source('outreach', 'account') }}

),

renamed as (

    select

        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('outreach', 'account')),
                staging_columns = get_staging_outreach_account_columns()
            )
        }}

    from source

),

final as (
    select
        account_id,
        company_type,
        linked_in_url,
        locality,
        number_of_employees,
        account_type,
        account_description,
        buyer_intent_score,
        founded_at,
        account_created_at,
        updater_id,
        sharing_team_id,
        website,
        industry,
        owner_id,
        domain,
        external_source,
        followers,
        updated_at,
        creator_id,
        custom_id,
        account_name,
        touched_at,
        parse_url(website) as extract_domain
    from renamed
)

select
    *,
    extract_domain:host as account_host
from final
