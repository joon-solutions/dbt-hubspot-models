{{ config(enabled=var('zendesk_enabled')) }}

with base as (

    select *
    from identifier('{{ source('zendesk', 'group') }}')

)

select *
from base
