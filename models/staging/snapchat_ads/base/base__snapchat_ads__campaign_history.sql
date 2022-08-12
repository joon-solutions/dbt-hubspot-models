with source as (

    select * from {{ source('snapchat_ads', 'campaign_history') }}

),

renamed as (

    select
        id as campaign_id,
        ad_account_id,
        name as campaign_name,
        _fivetran_synced,
        row_number() over (partition by campaign_id order by _fivetran_synced desc) = 1 as is_most_recent_record

    from source

)

select * from renamed
