with source as (

    select * from {{ source('hubspot', 'deal_pipeline_stage') }}

),

renamed as (

    select
        stage_id,
        pipeline_id,
        label,
        active,
        display_order,
        probability,
        closed_won,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed