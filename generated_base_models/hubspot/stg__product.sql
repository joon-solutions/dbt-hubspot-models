with source as (

    select * from {{ source('hubspot', 'product') }}

),

renamed as (

    select
        id,
        portal_id,
        is_deleted,
        property_hs_sku,
        property_price,
        property_createdate,
        property_hs_lastmodifieddate,
        property_hs_object_id,
        property_hs_updated_by_user_id,
        property_hs_created_by_user_id,
        property_name,
        _fivetran_synced,
        property_description,
        property_hs_cost_of_goods_sold,
        property_recurringbillingfrequency,
        property_hs_recurring_billing_period

    from source

)

select * from renamed