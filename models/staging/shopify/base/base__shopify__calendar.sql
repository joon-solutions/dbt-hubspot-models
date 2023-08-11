{{ config(enabled=var('shopify_enabled', False)) }}
{{ dbt_utils.date_spine(
    datepart="day",
    start_date=var('shopify_base_dates'),
    end_date="current_date"
   )
}}
