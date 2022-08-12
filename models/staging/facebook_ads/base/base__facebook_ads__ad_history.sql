with source as (

    select * from {{ source('facebook_ads', 'ad_history') }}

),

renamed as (

    select
        id as ad_id,
        account_id,
        ad_set_id,
        campaign_id,
        creative_id,
        name as ad_name,
        row_number() over (partition by id order by _fivetran_synced desc) = 1 as is_most_recent_record,
        _fivetran_synced,
        {{ dbt_utils.surrogate_key(['ad_id','_fivetran_synced']) }} as unique_id
    
    from source

)

select * from renamed
