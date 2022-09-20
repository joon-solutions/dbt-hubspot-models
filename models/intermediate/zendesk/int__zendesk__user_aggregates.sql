with users as (

    select * from {{ ref('base__zendesk__user') }}

),

user_tags as (

    select *
    from {{ ref('base__zendesk__user_tag') }}

),

user_tag_aggregate as (
    select
        user_id,
        {{ fivetran_utils.string_agg( 'tags', "', '" ) }} as user_tags
    from user_tags
    group by 1

),

final as (
    select
        users.*,
        user_tag_aggregate.user_tags
    from users
    left join user_tag_aggregate on users.user_id = user_tag_aggregate.user_id
)

select *
from final
