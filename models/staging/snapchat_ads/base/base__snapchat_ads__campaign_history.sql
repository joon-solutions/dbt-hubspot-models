{{ config(enabled=var('ad_reporting__snapchat_ads_enabled')) }}
with source as (

    select * from {{ source('snapchat_ads', 'campaign_history') }}

),

renamed as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('snapchat_ads', 'campaign_history')),
                staging_columns=get_snapchat_ads_campaign_history_columns()
            )
        }}
        -- id as campaign_id,
        -- ad_account_id,
        -- name as campaign_name,
        -- _fivetran_synced,
    from source

)

select 
        *,
        row_number() over (partition by campaign_id order by _fivetran_synced desc) = 1 as is_most_recent_record,
        {{ dbt_utils.surrogate_key(['campaign_id','_fivetran_synced']) }} as unique_id
from renamed
