{{ config(enabled=var('shopify_enabled', False)) }}

{%- set source_relation = adapter.get_relation(
      database=source('gsheet', 'inventory_level_user_input').database,
      schema=source('gsheet', 'inventory_level_user_input').schema,
      identifier=source('gsheet', 'inventory_level_user_input').name) -%}

{% set is_using_gsheet=source_relation is not none %}

select
    *,
    {{ dbt_utils.surrogate_key(['sku','source_relation']) }} as sku_globalid

    {% if is_using_gsheet %}
from {{ source('gsheet', 'inventory_level_user_input') }}

{% else %}
from {{ ref('seed__shopify__inventory_user_input') }}

    {% endif %}
