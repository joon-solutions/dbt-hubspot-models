with sf as (
    select * 
    from {{ ref('stg__salesforce__opportunity') }}
),

final as (
    select *
    from sf
)

select * from final