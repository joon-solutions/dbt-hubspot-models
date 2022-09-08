{{ config(enabled=var('ad_reporting__facebook_ads_enabled')) }}
with source as (

    select * from {{ source('facebook_ads', 'ad_set_history') }}

),

renamed as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('facebook_ads', 'ad_set_history')),
                staging_columns=get_facebook_ads_ad_set_history_columns()
            )
        }}
        
    from source
),

final as (

    select
        ad_set_id,
        account_id,
        campaign_id,
        ad_set_name,
        updated_time,
        row_number() over (partition by ad_set_id order by updated_time desc) = 1 as is_most_recent_record,
        {{ dbt_utils.surrogate_key(['ad_set_id','updated_time']) }} as unique_id
    from renamed

)

select * from final
