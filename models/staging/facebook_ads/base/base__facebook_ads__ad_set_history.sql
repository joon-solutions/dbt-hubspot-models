with source as (

    select * from {{ source('facebook_ads', 'ad_set_history') }}

),

renamed as (

    select
        id as ad_set_id,
        account_id,
        campaign_id,
        name as ad_set_name,
        row_number() over (partition by id order by _fivetran_synced desc) = 1 as is_most_recent_record,
        _fivetran_synced

    from source

)

select * from renamed