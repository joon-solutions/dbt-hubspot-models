{{ config(enabled=var('ad_reporting__snapchat_ads_enabled', False)) }}
with source as (

    select * from {{ source('snapchat_ads', 'creative_url_tag_history') }}

),

renamed as (

    select
        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('snapchat_ads', 'creative_url_tag_history')),
                staging_columns=get_snapchat_ads_creative_url_tag_history_columns()
            )
        }}
        -- creative_id,
        -- key as param_key,
        -- value as param_value,
        -- updated_at,  

    from source

)

select
    *,
    row_number() over (partition by creative_id, param_key order by updated_at desc) = 1 as is_most_recent_record,
    {{ dbt_utils.surrogate_key(['creative_id','updated_at','param_key','param_value']) }} as unique_id
from renamed
