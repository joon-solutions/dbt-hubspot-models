{{ config(enabled = var('email_subscription_enabled') ) }}

with source as (

    select * from {{ source('hubspot', 'email_subscription') }}

),

renamed as (

    select
        id as email_subscription_id,
        portal_id,
        name as subscription_name,
        description,
        active,
        _fivetran_synced

    from source

)

select * from renamed
