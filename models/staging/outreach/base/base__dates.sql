{{ config(
    materialized="table"
) }}

with base__dates as (
{{ dbt_date.get_date_dimension('2022-12-28 ', var('max_base_dates')) }}
)

select * from base__dates
