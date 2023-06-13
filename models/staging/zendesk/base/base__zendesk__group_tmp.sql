{{ config(enabled=var('zendesk_enabled', False)) }}

with base as (

    select *
    from identifier('{{ source('zendesk', 'group') }}')

)

select *
from base
