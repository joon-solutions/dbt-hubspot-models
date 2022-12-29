with unions as (

    {{ dbt_utils.union_relations(
        relations=[ref('base__salesforce__task'), ref('base__outreach__task')],
        source_column_name = None
    ) }}

)

select
    *,
    {{ dbt_utils.surrogate_key(['sf_task_id','outreach_task_id','source']) }} as task_id
from unions
