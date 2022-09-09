{{ config(enabled=var('ad_reporting__facebook_ads_enabled')) }}
with source as (

    select * from {{ source('facebook_ads', 'creative_history') }}

),

renamed as (

    select
        {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('facebook_ads', 'creative_history')),
                staging_columns=get_facebook_ads_creative_history_columns()
            )
        }}

    from source
),

final as (

    select
        _fivetran_id,
        creative_id,
        account_id,
        creative_name,
        page_link,
        template_page_link,
        url_tags,
        asset_feed_spec_link_urls,
        object_story_link_data_child_attachments,
        object_story_link_data_caption,
        object_story_link_data_description,
        object_story_link_data_link,
        object_story_link_data_message,
        template_app_link_spec_ios,
        row_number() over (partition by creative_id order by _fivetran_synced desc) = 1 as is_most_recent_record,
        {{ dbt_utils.surrogate_key(['creative_id','_fivetran_synced']) }} as unique_id

    from renamed

)

select * from final
