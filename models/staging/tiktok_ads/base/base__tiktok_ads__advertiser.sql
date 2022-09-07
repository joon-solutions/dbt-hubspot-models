{{ config(enabled=var('ad_reporting__tiktok_ads_enabled')) }}

with source as (

    select * from {{ source('tiktok_ads', 'advertiser') }}

),

renamed as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('tiktok_ads', 'advertiser')),
                staging_columns=get_tiktok_ads_adsvertiser_columns()
            )
        }}

    from source

)

select * from renamed
