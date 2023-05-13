{{ config(enabled=var('zendesk_enabled') and var("using_user_tags")) }}

with ticket_comment as (
    select *
    from {{ ref('base__zendesk__ticket_comment') }}

),

{% if var('zendesk__ticket_field_history', True) %}

ticket_history as (
    select *
    from {{ ref('base__zendesk__ticket_field_history') }}

),

{% endif %}

user as (
    select *
    from {{ ref('base__zendesk__user') }}
),

unioned as (

    {% if var('zendesk__ticket_field_history', True) %}
        select
            ticket_id,
            field_name,
            value,
            null as is_public,
            user_id,
            valid_starting_at,
            valid_ending_at,
            'ticket_field_history' as source,
            {{ dbt_utils.surrogate_key(['ticket_field_id','source']) }} as unique_id

        from ticket_history

        union all
    {% endif %}
    select
        ticket_id,
        cast('comment' as {{ dbt_utils.type_string() }}) as field_name,
        body as value,
        is_public,
        user_id,
        created_at as valid_starting_at,
        lead(created_at) over (partition by ticket_id order by created_at) as valid_ending_at,
        'ticket_comment' as source,
        {{ dbt_utils.surrogate_key(['ticket_comment_id','source']) }} as unique_id
    from ticket_comment

),

final as (
    select
        unioned.*,
        user.user_name,
        user.user_role
    from unioned
    left join user on unioned.user_id = user.user_id --many-to-one
)

select * from final
