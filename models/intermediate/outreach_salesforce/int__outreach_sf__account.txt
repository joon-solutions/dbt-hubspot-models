with sf as (
    select * 
    from {{ ref('base__salesforce__account') }}
),

outreach as (
    select * 
    from {{ ref('base__outreach__account') }}
),


final as (
    select *
    from sf
    left join outreach on sf.account_name = outreach.account_name
)

select * from final