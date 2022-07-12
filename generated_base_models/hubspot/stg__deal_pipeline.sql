with source as (

    select * from {{ source('hubspot', 'deal_pipeline') }}

),

renamed as (

    select
        pipeline_id,
        label,
        active,
        display_order,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed