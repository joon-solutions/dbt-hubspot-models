with source as (

    select * from {{ source('hubspot', 'line_item') }}

),

renamed as (

    select
        id,
        product_id,
        deal_id,
        is_deleted,
        property_price,
        property_createdate,
        property_description,
        property_hs_lastmodifieddate,
        property_quantity,
        property_hs_object_id,
        property_hs_updated_by_user_id,
        property_hs_created_by_user_id,
        property_hs_cost_of_goods_sold,
        property_name,
        _fivetran_synced,
        property_hs_position_on_quote,
        property_recurringbillingfrequency,
        property_hs_recurring_billing_period,
        property_hs_discount_percentage,
        property_hs_recurring_billing_start_date,
        property_discount

    from source

)

select * from renamed