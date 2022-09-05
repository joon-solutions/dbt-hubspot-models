{{ config(enabled=var('ad_reporting__snapchat_ads_enabled')) }}
with source as (

    select * from {{ source('snapchat_ads', 'ad_history') }}

),

renamed as (

    select
        id as ad_id,
        ad_squad_id,
        creative_id,
        name as ad_name,
        _fivetran_synced,
        row_number() over (partition by ad_id order by _fivetran_synced desc) = 1 as is_most_recent_record,
        {{ dbt_utils.surrogate_key(['ad_id','_fivetran_synced']) }} as unique_id


    from source

)

select * from renamed