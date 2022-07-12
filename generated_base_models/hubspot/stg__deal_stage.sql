with source as (

    select * from {{ source('hubspot', 'deal_stage') }}

),

renamed as (

    select
        deal_id,
        value,
        source_id,
        source,
        date_entered,
        _fivetran_synced,
        _fivetran_start,
        _fivetran_end,
        _fivetran_active

    from source

)

select * from renamed