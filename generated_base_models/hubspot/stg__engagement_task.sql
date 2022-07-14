with source as (

    select * from {{ source('hubspot', 'engagement_task') }}

),

renamed as (

    select
        engagement_id,
        body,
        subject,
        status,
        for_object_type,
        task_type,
        completion_date,
        is_all_day,
        priority,
        _fivetran_synced

    from source

)

select * from renamed