{{ config(enabled=var('ad_reporting__snapchat_ads_enabled')) }}
with source as (

    select * from {{ source('snapchat_ads', 'ad_squad_history') }}

),

renamed as (

    select
        id as ad_squad_id,
        campaign_id,
        name as ad_squad_name,
        _fivetran_synced,
        row_number() over (partition by ad_squad_id order by _fivetran_synced desc) = 1 as is_most_recent_record,
        {{ dbt_utils.surrogate_key(['ad_squad_id','_fivetran_synced']) }} as unique_id

    from source

)

select * from renamed
