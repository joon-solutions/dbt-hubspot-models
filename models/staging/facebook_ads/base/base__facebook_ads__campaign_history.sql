{{ config(enabled=var('ad_reporting__facebook_ads_enabled')) }}
with source as (

    select * from {{ source('facebook_ads', 'campaign_history') }}

),

renamed as (

    select
        id as campaign_id,
        account_id,
        name as campaign_name,
        _fivetran_synced,
        row_number() over (partition by id order by _fivetran_synced desc) = 1 as is_most_recent_record,
        {{ dbt_utils.surrogate_key(['campaign_id','_fivetran_synced']) }} as unique_id

    from source

)

select * from renamed