{{ config(enabled=
    var('ad_reporting__pinterest_enabled') 
    or var('ad_reporting__microsoft_ads_enabled')
    or var('ad_reporting__linkedin_ads_enabled')
    or var('ad_reporting__twitter_ads_enabled')
    or var('ad_reporting__google_ads_enabled')
    or var('ad_reporting__facebook_ads_enabled')
    or var('ad_reporting__snapchat_ads_enabled')
    or var('ad_reporting__tiktok_ads_enabled')
  ) }}
{{ config(materialized='table') }}

with unioned as (

    {{ dbt_utils.union_relations(get_staging_files()) }}

)

select
    *,
    {{ dbt_utils.surrogate_key(['unique_id','platform']) }} as id
from unioned
