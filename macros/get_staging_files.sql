{% macro get_staging_files() %}

    {% set staging_file = [] %}

    {% if var('ad_reporting__pinterest_enabled') %} 
    {% set _ = staging_file.append(ref('int__pinterest_ads')) %}
    {% endif %}

    {% if var('ad_reporting__microsoft_ads_enabled') %} 
    {% set _ = staging_file.append(ref('int__microsoft_ads')) %}
    {% endif %}

    {% if var('ad_reporting__linkedin_ads_enabled') %} 
    {% set _ = staging_file.append(ref('int__linkedin_ads')) %}
    {% endif %}

    {% if var('ad_reporting__twitter_ads_enabled') %} 
    {% set _ = staging_file.append(ref('int__twitter_ads')) %}
    {% endif %}

    {% if var('ad_reporting__google_ads_enabled') %} 
    {% set _ = staging_file.append(ref('int__google_ads')) %}
    {% endif %}

    {% if var('ad_reporting__facebook_ads_enabled') and var('ad_reporting__facebook_ads_basic_ad_enabled') %}
    {% set _ = staging_file.append(ref('int__facebook_ads')) %}
    {% endif %}

    {% if var('ad_reporting__snapchat_ads_enabled') %} 
    {% set _ = staging_file.append(ref('int__snapchat_ads')) %}
    {% endif %}

    {% if var('ad_reporting__tiktok_ads_enabled') %} 
    {% set _ = staging_file.append(ref('int__tiktok_ads')) %}
    {% endif %}

    {{ log("Staging file" ~ staging_file)}}


    {{ return(staging_file) }}

{% endmacro %}


