with source as (

    select * from {{ source('hubspot', 'engagement_note') }}

),

renamed as (

    select
        engagement_id,
        body,
        _fivetran_synced

    from source

)

select * from renamed