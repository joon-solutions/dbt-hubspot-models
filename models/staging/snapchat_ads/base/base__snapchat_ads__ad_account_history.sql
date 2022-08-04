with source as (

    select * from {{ source('snapchat_ads', 'ad_account_history') }}

),

renamed as (

    select
        id as ad_account_id,
        name as ad_account_name,
        _fivetran_synced,
        row_number() over (partition by ad_account_id order by _fivetran_synced desc) = 1 as is_most_recent_record

    from source

)

select * from renamed