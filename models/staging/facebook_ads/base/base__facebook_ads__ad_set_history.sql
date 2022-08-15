{{ config(enabled=var('ad_reporting__facebook_ads_enabled')) }}
with source as (

    select * from {{ source('facebook_ads', 'ad_set_history') }}

),

renamed as (

    select
        id as ad_set_id,
        account_id,
        campaign_id,
        name as ad_set_name,
        updated_time,
        row_number() over (partition by id order by updated_time desc) = 1 as is_most_recent_record,
        {{ dbt_utils.surrogate_key(['ad_set_id','updated_time']) }} as unique_id

    from source

)

select * from renamed
