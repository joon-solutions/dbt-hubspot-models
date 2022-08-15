{{ config(enabled=var('ad_reporting__snapchat_ads_enabled')) }}
with source as (

    select * from {{ source('snapchat_ads', 'creative_url_tag_history') }}

),

renamed as (

    select
        creative_id,
        key as param_key,
        value as param_value,
        updated_at,
        row_number() over (partition by creative_id, param_key order by updated_at desc) = 1 as is_most_recent_record

    from source

)

select * from renamed
