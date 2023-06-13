{{ config(enabled=var('ad_reporting__facebook_ads_enabled', False)) }}
with source as (

    select * from {{ source('facebook_ads', 'ad_history') }}

),

renamed as (

    select
        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('facebook_ads', 'ad_history')),
                staging_columns=get_facebook_ads_ad_history_columns()
            )
        }}

    from source
),

final as (

    select
        ad_id,
        account_id,
        ad_set_id,
        campaign_id,
        creative_id,
        ad_name,
        row_number() over (partition by ad_id order by _fivetran_synced desc) = 1 as is_most_recent_record,
        _fivetran_synced,
        {{ dbt_utils.surrogate_key(['ad_id','_fivetran_synced']) }} as unique_id

    from renamed

)

select * from final
