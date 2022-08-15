with source as (

    select * from {{ source('google_ads', 'criteria_performance') }}

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
        cost,
        criteria,
        criteria_destination_url,
        criteria_type,
        date,
        external_customer_id,
        id,
        impressions

    from source

)

select * from renamed