with source as (

    select * from {{ source('pinterest_ads', 'ad_group_history') }}

),

renamed as (

    select
        id as ad_group_id,
        campaign_id,
        created_time,
        name,
        status,
        start_time,
        end_time,
        _fivetran_synced,
        {{ dbt_utils.surrogate_key(['ad_group_id','_fivetran_synced'] )}} as version_id,
        row_number() over (partition by ad_group_id order by _fivetran_synced desc) as is_latest_version

    from source

)

select * from renamed
