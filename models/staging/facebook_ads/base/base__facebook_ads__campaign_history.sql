with source as (

    select * from {{ source('facebook_ads', 'campaign_history') }}

),

renamed as (

    select
        id as campaign_id,
        account_id,
        name as campaign_name,
        row_number() over (partition by id order by _fivetran_synced desc) = 1 as is_most_recent_record

    from source

)

select * from renamed