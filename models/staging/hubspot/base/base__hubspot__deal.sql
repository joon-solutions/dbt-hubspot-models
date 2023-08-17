{{ config(enabled = var('hubspot__deal', False) ) }}

with source as (

    select * from {{ source('hubspot', 'deal') }}

),

renamed as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('hubspot', 'deal')),
                staging_columns=get_hubspot_deal_columns()
            )
        }}
    from source

)

select *
from renamed
