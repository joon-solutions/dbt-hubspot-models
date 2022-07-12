with source as (

    select * from {{ source('hubspot', 'engagement_company') }}

),

renamed as (

    select
        engagement_id,
        company_id,
        _fivetran_synced

    from source

)

select * from renamed