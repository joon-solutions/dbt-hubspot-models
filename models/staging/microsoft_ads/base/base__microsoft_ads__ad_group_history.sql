with source as (

    select * from {{ source('microsoft_ads', 'ad_group_history') }}

),

renamed as (

    select
        id as ad_group_id,
        campaign_id,
        name as ad_group_name,
        modified_time as modified_timestamp,
        {{ dbt_utils.surrogate_key(['ad_group_id','modified_timestamp']) }} as ad_group_version_id,
        row_number() over (partition by ad_group_id order by modified_timestamp desc) = 1 as is_most_recent_version

    from source

)

select * from renamed
