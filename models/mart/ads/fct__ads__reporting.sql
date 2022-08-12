{{ config(materialized='table') }}

with unioned as (

    {{ dbt_utils.union_relations(get_staging_files()) }}

)

select *,
        {{ dbt_utils.surrogate_key(['unique_id','platform']) }} as id
from unioned