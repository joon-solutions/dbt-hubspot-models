{{ config(enabled=var('shopify__location', True)) }}

with base as (

    select * from {{ ref('base__shopify__location_tmp') }}

),

final as (

    select
        id as location_id,
        province,
        city,
        country,
        {{ dbt_date.convert_timezone(column='cast(_fivetran_synced as ' ~ dbt_utils.type_timestamp() ~ ')', target_tz=var('shopify_timezone', "UTC"), source_tz="UTC") }} as _fivetran_synced
    from base
)

select *
from final
