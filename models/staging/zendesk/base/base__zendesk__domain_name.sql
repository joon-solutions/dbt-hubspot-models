--To disable this model, set the zendesk__domain_names variable within your dbt_project.yml file to False.
{{ config(enabled=var('zendesk__domain_names', True)) }}

with base as (

    select * 
    from {{ source('zendesk', 'domain_name') }}

),

fields as (

    select

        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('zendesk', 'domain_name')),
                staging_columns=get_zendesk_domain_name_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        organization_id,
        domain_name,
        index,
        {{ dbt_utils.surrogate_key(['organization_id','index']) }} as unique_id
    from fields
)

select * 
from final
