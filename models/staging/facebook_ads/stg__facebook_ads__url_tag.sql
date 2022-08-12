with base as (

    select *
    from {{ ref('base__facebook_ads__creative_history') }}

),

required_fields as (

    select
        _fivetran_id,
        creative_id,
        parse_json(url_tags) as url_tags
    from base
    where url_tags is not null


),

flattened_url_tags as (

    select
        _fivetran_id,
        creative_id,
        url_tags.value:key::string as key,
        url_tags.value:value::string as value,
        url_tags.value:type::string as type
    from required_fields,
    lateral flatten( input => url_tags ) as url_tags


)

select
*,
        {{ dbt_utils.surrogate_key(['_fivetran_id','key','type']) }} as unique_id
from flattened_url_tags
