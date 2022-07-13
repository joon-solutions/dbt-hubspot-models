with source as (

    select * from {{ source('hubspot', 'email_subscription_change') }}

),

renamed as (

    select
        {{ dbt_utils.surrogate_key(['recipient','timestamp']) }} as id,
        recipient,
        timestamp as created_at,
        change,
        change_type,
        portal_id,
        source,
        caused_by_event_id, ---caused_by_event_id:recipient - n:1
        email_subscription_id,
        _fivetran_id,
        _fivetran_synced

    from source

)

select * from renamed

