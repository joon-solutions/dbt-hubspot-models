{{ config(enabled=var('ad_reporting__snapchat_ads_enabled')) }}
with source as (

    select * from {{ source('snapchat_ads', 'creative_history') }}

),

renamed as (

    select
        id as creative_id,
        ad_account_id,
        name as creative_name,
        web_view_url as url,
        _fivetran_synced,
        row_number() over (partition by creative_id order by _fivetran_synced desc) = 1 as is_most_recent_record

    from source

)

select * from renamed
