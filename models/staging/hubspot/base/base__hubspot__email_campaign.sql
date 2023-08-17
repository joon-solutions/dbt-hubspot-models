{{ config(enabled = var('email_campaign_enabled', False) ) }}

with source as (

    select * from {{ source(var('hubspot_schema', 'hubspot'), 'email_campaign') }}

),

renamed as (

    select
        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source(var('hubspot_schema', 'hubspot'), 'email_campaign')),
                staging_columns = get_hubspot_email_campaign_columns()
            )
        }}

    from source

)

select * from renamed
