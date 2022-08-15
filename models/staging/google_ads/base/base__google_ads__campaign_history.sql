{{ config(enabled=var('ad_reporting__google_ads_enabled')) }}
with source as (

    select * from {{ source('google_ads', 'campaign_history') }}

),

renamed as (

    select
        id as campaign_id,
        updated_at as updated_timestamp,
        _fivetran_synced,
        name as campaign_name,
        customer_id as account_id,
        row_number() over (partition by campaign_id order by updated_timestamp desc) = 1 as is_most_recent_record,
        {{ dbt_utils.surrogate_key(['campaign_id','_fivetran_synced']) }} as unique_id

    from source

)

select * from renamed
