{{ config(enabled=var('ad_reporting__tiktok_ads_enabled')) }}

with source as (

    select * from {{ source('tiktok_ads', 'advertiser') }}

),

renamed as (

    select
        id as advertiser_id,
        name,
        address,
        company,
        contacter,
        country,
        currency,
        description,
        email,
        industry,
        license_no,
        license_url,
        promotion_area,
        reason,
        role,
        status,
        telephone,
        timezone,
        balance,
        create_time,
        language,
        phone_number,
        _fivetran_synced

    from source

)

select * from renamed