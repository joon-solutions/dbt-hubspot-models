{{ config(enabled=var('shopify_enabled', False)) }}

with products as (

    select *
    from {{ ref('base__shopify__product') }}
),

collection_product as (

    select *
    from {{ ref('base__shopify__collection_product') }} --need to create
),

collection as (

    select *
    from {{ ref('base__shopify__collection') }} --need to create
    where not coalesce(is_deleted, false) -- limit to only active collections
),

product_tag as (

    select *
    from {{ ref('base__shopify__product_tag') }}
),

product_variant as (

    select *
    from {{ ref('base__shopify__product_variant') }}
),

product_image as (

    select *
    from {{ ref('base__shopify__product_image') }}
),

collections_aggregated as (

    select
        collection_product.product_globalid,
        {{ fivetran_utils.string_agg(field_to_agg='collection.title', delimiter="', '") }} as collections
    from collection_product
    inner join collection on collection_product.collection_globalid = collection.collection_globalid
    group by 1
),

tags_aggregated as (

    select
        product_globalid,
        {{ fivetran_utils.string_agg(field_to_agg='value', delimiter="', '") }} as tags
    from product_tag
    group by 1
),

variants_aggregated as (

    select
        product_globalid,
        count(product_variant_globalid) as count_variants
    from product_variant
    group by 1

),

images_aggregated as (

    select
        product_globalid,
        count(*) as count_images
    from product_image
    group by 1
),

joined as (

    select
        products.*,
        collections_aggregated.collections,
        tags_aggregated.tags,
        variants_aggregated.count_variants,
        coalesce(images_aggregated.count_images, 0) > 0 as has_product_image

    from products
    left join collections_aggregated
        on products.product_globalid = collections_aggregated.product_globalid
    left join tags_aggregated
        on products.product_globalid = tags_aggregated.product_globalid
    left join variants_aggregated
        on products.product_globalid = variants_aggregated.product_globalid
    left join images_aggregated
        on products.product_globalid = images_aggregated.product_globalid
)

select *
from joined
