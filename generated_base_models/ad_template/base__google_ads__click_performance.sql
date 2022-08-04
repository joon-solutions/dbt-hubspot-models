with source as (

    select * from {{ source('google_ads', 'click_performance') }}

),

renamed as (

    select
        _fivetran_id,
        _fivetran_synced,
        account_descriptive_name,
        ad_group_id,
        ad_group_name,
        ad_group_status,
        campaign_id,
        campaign_name,
        campaign_status,
        clicks,
        criteria_id,
        date,
        external_customer_id,
        gcl_id

    from source

)

select * from renamed