with source as (

    select * from {{ source('pinterest_ads', 'campaign_history') }}

),

renamed as (

    select
        id as campaign_id,
        created_time,
        name,
        status,
        _fivetran_synced,
        {{ dbt_utils.surrogate_key(['campaign_id','_fivetran_synced'] )}} as version_id,
        row_number() over (partition by campaign_id order by _fivetran_synced desc) as is_latest_version

    from source

)

select * from renamed
