{{ config(enabled = var('outreach_task') ) }}

with source as (

    select * from {{ source('outreach', 'task') }}

),

renamed as (

    select

        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('outreach', 'task')),
                staging_columns = get_staging_outreach_task_columns()
            )
        }}

    from source

),

final as (
    select
        null as sf_task_id,
        null as sf_account_id,
        task_id as outreach_task_id,
        account_id as outreach_account_id,
        task_action_type,
        completed_at,
        is_completed,
        task_state,
        task_due_at,
        'outreach' as source
    from renamed
)

select *
from final
