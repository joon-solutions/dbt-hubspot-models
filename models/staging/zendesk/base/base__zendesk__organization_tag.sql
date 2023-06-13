{{ config(enabled=var('zendesk_enabled', False) and var('using_organization_tags', False)) }}

with base as (

    select * 
    from {{ source('zendesk', 'organization_tag') }}

),

fields as (

    select

        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('zendesk', 'organization_tag')),
                staging_columns=get_zendesk_organization_tag_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        organization_id,
        tags,
        {{ dbt_utils.surrogate_key(['organization_id','tags']) }} as unique_id
    from fields
)

select * 
from final
