with source as (

    select * from {{ source('hubspot', 'engagement_deal') }}

),

renamed as (

    select
        engagement_id,
        deal_id,
        _fivetran_synced

    from source

)

select * from renamed