{{ config(enabled=var('ad_reporting__snapchat_ads_enabled', False)) }}
with source as (

    select * from {{ source('snapchat_ads', 'ad_squad_history') }}

),

renamed as (

    select
        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('snapchat_ads', 'ad_squad_history')),
                staging_columns=get_snapchat_ads_ad_squad_history_columns()
            )
        }}


    from source

)

select
    *,
    row_number() over (partition by ad_squad_id order by _fivetran_synced desc) = 1 as is_most_recent_record,
    {{ dbt_utils.surrogate_key(['ad_squad_id','_fivetran_synced']) }} as unique_id
from renamed
