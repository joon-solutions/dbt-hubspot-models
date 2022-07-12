with source as (

    select * from {{ source('hubspot', 'identity_profile_identity') }}

),

renamed as (

    select
        identity_vid,
        value,
        type,
        timestamp,
        is_primary,
        is_secondary,
        _fivetran_synced

    from source

)

select * from renamed