with source as (

    select * from {{ source('hubspot', 'ticket_pipeline_stage') }}

),

renamed as (

    select
        stage_id,
        pipeline_id,
        label,
        active,
        display_order,
        is_closed,
        ticket_state,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed