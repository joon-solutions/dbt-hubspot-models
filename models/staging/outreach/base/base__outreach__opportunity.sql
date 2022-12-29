
{{ config(enabled = var('outreach_opportunity') ) }}

with source as (

    select * from {{ source('outreach', 'opportunity') }}

),

renamed as (

    select

        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('outreach', 'opportunity')),
                staging_columns = get_staging_outreach_opportunity_columns()
            )
        }}

    from source

)

select
    *
-- ,regexp_substr(regexp_replace(website,'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)')) as sf_domain 
from renamed