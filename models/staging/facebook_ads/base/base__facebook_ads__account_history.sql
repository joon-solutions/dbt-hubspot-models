with source as (

    select * from {{ source('facebook_ads', 'account_history') }}

),

renamed as (

    select
        id as account_id,
        name as account_name,
        _fivetran_synced,
        row_number() over (partition by id order by _fivetran_synced desc) = 1 as is_most_recent_record

    from source

)

select * from renamed