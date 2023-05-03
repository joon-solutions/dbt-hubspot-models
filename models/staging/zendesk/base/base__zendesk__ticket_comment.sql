{{ config(enabled=var('zendesk_enabled')) }}

with base as (

    select *
    from {{ source('zendesk', 'ticket_comment') }}

),

fields as (

    select

        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('zendesk', 'ticket_comment')),
                staging_columns=get_zendesk_ticket_comment_columns()
            )
        }}

    from base
),

final as (

    select
        ticket_comment_id,
        _fivetran_synced,
        body,
        created as created_at,
        is_public,
        ticket_id,
        user_id,
        is_facebook_comment,
        is_tweet,
        is_voice_comment
    from fields
)

select *
from final
