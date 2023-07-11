{%- set source_relation = adapter.get_relation(
      database=source('shopify', 'inventory_level_user_input').database,
      schema=source('shopify', 'inventory_level_user_input').schema,
      identifier=source('shopify', 'inventory_level_user_input').name) -%}

{% set table_exists=source_relation is not none %}

{% if table_exists %}

select * from {{ source('shopify', 'inventory_level_user_input') }}

{% else %}

select * from {{ ref('seed__shopify__inventory_user_input') }}

{% endif %}
