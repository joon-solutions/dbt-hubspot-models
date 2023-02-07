-- requires any extra columns from table_join_on to be listed prior to using this macro.
-- assumes we have replaced instances of valid_to = null with a future_proof_date = '9999-12-31'.
 
{% macro join_snapshots(cte_join, cte_join_on, cte_join_valid_to,
   cte_join_valid_from, cte_join_on_valid_to, cte_join_on_valid_from,
   cte_join_id, cte_join_on_id) %}

        case 
            -- since we're using outer join, valid_from could be null for one of the sources.
            -- this condition sets the final joined valid_from to be the not null one. 
            when {{cte_join}}.{{cte_join_valid_from}} is null or {{cte_join_on}}.{{cte_join_valid_from}} is null 
                then coalesce({{cte_join}}.{{cte_join_valid_from}}, {{cte_join_on}}.{{cte_join_valid_from}})
            -- if both of them have values, The joining logic finds where the ids match and where the timestamps overlap between the two tables.
            else greatest({{cte_join}}.{{cte_join_valid_from}},
               coalesce( {{cte_join_on}}.{{cte_join_on_valid_from}}, {{cte_join}}.{{cte_join_valid_from}}))
        end as {{cte_join}}_{{cte_join_on}}_valid_from,
        case 
            -- since we're using outer join, valid_from could be null for one of the sources.
            -- this condition sets the final joined valid_from to be the not null one. 
            when {{cte_join}}.{{cte_join_valid_from}} is null or {{cte_join_on}}.{{cte_join_valid_from}} is null 
                then coalesce({{cte_join}}.{{cte_join_valid_to}}, {{cte_join_on}}.{{cte_join_valid_to}})
            else least({{cte_join}}.{{cte_join_valid_to}},
                coalesce({{cte_join_on}}.{{cte_join_on_valid_to}}, {{cte_join}}.{{cte_join_valid_to}})) 
        end as {{cte_join}}_{{cte_join_on}}_valid_to
  
   from {{cte_join}}
   full outer join {{cte_join_on}} on {{cte_join}}.{{cte_join_id}} = {{cte_join_on}}.{{cte_join_on_id}}
       and (({{cte_join_on}}.{{cte_join_on_valid_from}} >= {{cte_join}}.{{cte_join_valid_from}}
       and {{cte_join_on}}.{{cte_join_on_valid_from}} < {{cte_join}}.{{cte_join_valid_to}})
       or ({{cte_join_on}}.{{cte_join_on_valid_to}} >= {{cte_join}}.{{cte_join_valid_from}}
       and {{cte_join_on}}.{{cte_join_on_valid_to}} < {{cte_join}}.{{cte_join_valid_to}}))
      
  
{% endmacro %}