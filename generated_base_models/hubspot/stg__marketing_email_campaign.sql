with source as (

    select * from {{ source('hubspot', 'marketing_email_campaign') }}

),

renamed as (

    select
        campaign_id,
        marketing_email_id,
        _fivetran_synced

    from source

)

select * from renamed