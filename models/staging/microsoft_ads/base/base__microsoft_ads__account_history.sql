with source as (

    select * from {{ source('microsoft_ads', 'account_history') }}

),

renamed as (

    select
        id as account_id,
        name as account_name,
        last_modified_time as modified_timestamp,
        {{ dbt_utils.surrogate_key(['account_id','modified_timestamp']) }} as account_version_id,
        row_number() over (partition by account_id order by modified_timestamp desc) = 1 as is_most_recent_version

    from source

)

select * from renamed
