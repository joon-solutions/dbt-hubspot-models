with sf as (
    select  
            task_id as sf_task_id,
            account_id as sf_account_id,
            null as outreach_task_id,
            null as outreach_account_id,
            task_action_type,
            completed_at,
            is_completed,
            'salesforce' as source
    from {{ ref('base__salesforce__task') }}
), 

outreach as (
    select  
            null as sf_task_id,
            null as sf_account_id,
            task_id as outreach_task_id,
            account_id as outreach_account_id,
            task_action_type,
            completed_at,
            is_completed,
            'outreach' as source
    from {{ ref('base__outreach__task') }}
),

final as (
    select * from sf
    union all
    select * from outreach
)

select 
        *,
        {{ dbt_utils.surrogate_key(['sf_task_id','outreach_task_id','source']) }} as task_id
from final