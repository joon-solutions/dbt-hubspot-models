{{ config(enabled=var('ad_reporting__microsoft_ads_enabled')) }}
with source as (

    select * from {{ source('microsoft_ads', 'campaign_history') }}

),

renamed as (

    select
        id as campaign_id,
        account_id,
        name as campaign_name,
        modified_time as modified_timestamp,
        {{ dbt_utils.surrogate_key(['campaign_id','modified_timestamp']) }} as campaign_version_id,
        row_number() over (partition by campaign_id order by modified_timestamp desc) = 1 as is_most_recent_version

    from source

)

select * from renamed
