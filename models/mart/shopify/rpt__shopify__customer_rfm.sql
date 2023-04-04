with customers as (

    select *
    from {{ ref('fct__shopify__customers') }}

),

rfm_bin as (

    select
        *,
        ntile(5) over (order by lifetime_total_net asc) as rfm_frequency_score,
        ntile(5) over (order by lifetime_count_orders asc) as rfm_monetary_score,
        ntile(5) over (order by days_since_last_orders desc) as rfm_recency_score
    from customers

),

mf_bin as (
    select
        *,
        ntile(5) over (order by (rfm_monetary_score * {{ var('m_weight') }} + rfm_frequency_score * {{ var('f_weight') }}) asc) as rfm_monetary_frequency_score
    from rfm_bin
),

segment as (

    select
        *,
        case    ---lost customers
            when rfm_recency_score <= 2 and rfm_monetary_frequency_score = 5 then 'Cant lose them'
            when rfm_recency_score <= 2 and rfm_monetary_frequency_score in (3, 4) then 'Hibernating'
            when rfm_recency_score <= 2 and rfm_monetary_frequency_score in (1, 2) then 'Lost'
            ---losing customers
            when rfm_recency_score = 3 and rfm_monetary_frequency_score = 3 then 'Need attention'
            when rfm_recency_score = 3 and rfm_monetary_frequency_score in (1, 2) then 'About to sleep'
            when rfm_recency_score in (3, 4) and rfm_monetary_frequency_score in (4, 5) then 'Loyal customers'
            -- most recent customers
            when rfm_recency_score in (4, 5) and rfm_monetary_frequency_score = 1 then 'New customers'
            when rfm_recency_score in (4, 5) and rfm_monetary_frequency_score in (2, 3) then 'Promising'
            when rfm_recency_score in (4, 5) and rfm_monetary_frequency_score in (4, 5) then 'Champions'
        end as rfm_segment
    from mf_bin
)

select *
from segment
