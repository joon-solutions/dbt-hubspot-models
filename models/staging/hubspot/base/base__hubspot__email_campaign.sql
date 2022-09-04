{{ config(enabled = var('email_campaign_enabled') ) }}

with source as (

    select * from {{ source('hubspot', 'email_campaign') }}

),

renamed as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('hubspot', 'email_campaign')),
                staging_columns = get_hubspot_email_campaign_columns()
            )
        }}

    from source

)

select * from renamed
