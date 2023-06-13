{{ config(enabled=var('shopify_enabled', False)) }}

with calendar as (

    select *
    from {{ ref('base__shopify__calendar') }}
    where cast({{ dbt_utils.date_trunc('month','date_day') }} as date) = date_day
),

customers as (

    select *
    from {{ ref('fct__shopify__customers') }}
),


orders as (

    select *
    from {{ ref('fct__shopify__orders') }}
),

orders_agg as (

    select
        customer_globalid,
        customer_id,
        source_relation,
        cast({{ dbt_utils.date_trunc('month', 'created_timestamp') }} as date) as order_month,
        max(created_timestamp) as most_recent_order_timestamp_within_month,
        count(distinct order_id) as count_orders,
        sum(order_value) as total_spent,
        sum(order_refund_value) as total_refunded,
        sum(order_value) - sum(order_refund_value) as total_net,

        {% if fivetran_utils.enabled_vars(['shopify__order_shipping_line', 'shopify__order_shipping_tax_line']) %}
        sum(order_total_shipping) as total_shipping,
        {% endif %}

        sum(order_total_tax) as total_tax,
        sum(order_total_discount) as total_discount
    from orders
    group by 1, 2, 3, 4

),

---- Set the partition window to calculate the accumulative metrics of each customer from the beginning up till the report_month
{% set partition_string = 'partition by customers.customer_globalid order by date_month rows between unbounded preceding and current row' %}

orders_calendar as (

    select
        calendar.date_day as date_month,
        ----customers attributes
        customers.customer_globalid,
        customers.customer_id,
        customers.source_relation,
        customers.email,
        customers.created_timestamp,
        customers.full_name,
        customers.account_state,
        customers.customer_tags,
        customers.phone,
        customers.first_order_timestamp,
        customers.default_address_id,
        ----orders attributes
        coalesce(sum(orders_agg.count_orders) over ({{ partition_string }}), 0) as lifetime_count_orders,
        coalesce(sum(orders_agg.total_spent) over ({{ partition_string }}), 0) as lifetime_total_spent,
        coalesce(sum(orders_agg.total_refunded) over ({{ partition_string }}), 0) as lifetime_total_refunded,
        coalesce(sum(orders_agg.total_net) over ({{ partition_string }}), 0) as lifetime_total_net,

        {% if fivetran_utils.enabled_vars(['shopify__order_shipping_line', 'shopify__order_shipping_tax_line']) %}
        coalesce(sum(orders_agg.total_shipping) over ({{ partition_string }}), 0) as lifetime_total_shipping,
        {% endif %}

        coalesce(sum(orders_agg.total_tax) over ({{ partition_string }}), 0) as lifetime_total_tax,
        coalesce(sum(orders_agg.total_discount) over ({{ partition_string }}), 0) as lifetime_total_discount,
        max(orders_agg.most_recent_order_timestamp_within_month) over ({{ partition_string }}) as most_recent_order_timestamp,
        ---For current month, days since last orders will be calculated from today backwards. For other historical months, its calculated from last day of same month backwards
        case when date_trunc('month', sysdate()) = calendar.date_day then datediff(day, most_recent_order_timestamp, convert_timezone('UTC', {{ var('shopify_timezone', "'UTC'") }}, sysdate() ))
            else datediff(day, most_recent_order_timestamp, convert_timezone('UTC', {{ var('shopify_timezone', "'UTC'") }}, last_day(calendar.date_day) ))
        end as days_since_last_orders

    from calendar
    --need to join with customeres first to create a customer base - even customers who didnt have any order in the same month were still present
    left join customers on calendar.date_day >= date(customers.created_timestamp)  --one-to-many
    left join orders_agg on customers.customer_globalid = orders_agg.customer_globalid
                            -- and customers.source_relation = orders_agg.source_relation
                            and calendar.date_day = orders_agg.order_month --one-to-one

),

rfm_bin as (

    select
        *,
        ntile(5) over (partition by date_month order by lifetime_count_orders asc) as rfm_frequency_score,
        ntile(5) over (partition by date_month order by lifetime_total_net asc) as rfm_monetary_score,
        ntile(5) over (partition by date_month order by days_since_last_orders desc) as rfm_recency_score
    from orders_calendar

),

mf_bin as (
    select
        *,
        ntile(5) over (partition by date_month order by (rfm_monetary_score * {{ var('m_weight') }} + rfm_frequency_score * {{ var('f_weight') }}) asc) as rfm_monetary_frequency_score
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

select
    *,
    {{ dbt_utils.surrogate_key(['date_month', 'customer_id', 'source_relation']) }} as unique_id
from segment
