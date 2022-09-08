{{ config(enabled=var('ad_reporting__facebook_ads_enabled')) }}
with source as (

    select * from {{ source('facebook_ads', 'basic_ad') }}

),

renamed as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('facebook_ads', 'basic_ad')),
                staging_columns=get_facebook_ads_basic_ad_columns()
            )
        }}
        
    from source
),

final as (

    select
        ad_id,
        date_day,
        account_id,
        impressions,
        clicks,
        spend,
        {{ dbt_utils.surrogate_key(['ad_id','account_id','date_day']) }} as unique_id

    from renamed

)

select * from final
