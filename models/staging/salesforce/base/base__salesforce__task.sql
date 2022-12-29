--To disable this model, set the below variable within your dbt_project.yml file to False.
{{ config(enabled=var('salesforce__task_enabled', True)) }}

with source as (

    select * from {{ source('salesforce', 'task') }}

),

renamed as (

    select

    {{
        fivetran_utils.fill_staging_columns(
            source_columns=adapter.get_columns_in_relation(source('salesforce', 'task')),
            staging_columns = get_salesforce_task_columns()
        )
    }}

    from source
),

final as (
    select
        task_id as sf_task_id,
        account_id as sf_account_id,
        null as outreach_task_id,
        null as outreach_account_id,
        task_action_type,
        completed_at,
        is_completed,
        task_state,
        task_due_at,
        'salesforce' as source
    from renamed
)

select *
from final
