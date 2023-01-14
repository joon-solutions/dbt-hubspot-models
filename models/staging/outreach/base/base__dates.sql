{{ config(
    materialized="table"
) }}

with base__dates as (
{{ dbt_date.get_date_dimension(var('min_base_dates'), var('max_base_dates')) }}
)

select * from base__dates
