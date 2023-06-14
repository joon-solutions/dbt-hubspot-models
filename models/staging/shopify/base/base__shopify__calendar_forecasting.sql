{{ dbt_utils.date_spine(
    datepart="day",
    start_date=var('shopify_base_dates'),
    end_date="dateadd(year, 1, date_trunc(month, current_date()))"
   )
}}
