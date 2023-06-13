{{ config(enabled=var('zendesk_enabled', false) and var("using_user_tags", false)) }}

with base as (

    select *
    from {{ source('zendesk', 'user_tag') }}

),

fields as (

    select
        /*
        The below macro is used to generate the correct SQL for package staging models. It takes a list of columns
        that are expected/needed (staging_columns from dbt_zendesk_source/models/tmp/) and compares it with columns
        in the source (source_columns from dbt_zendesk_source/macros/).
        For more information refer to our dbt_fivetran_utils documentation (https://github.com/fivetran/dbt_fivetran_utils.git).
        */
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('zendesk', 'user_tag')),
                staging_columns=get_zendesk_user_tag_columns()
            )
        }}

    from base
),

final as (

    select
        user_id,
        tags,
        {{ dbt_utils.surrogate_key(['user_id','tags']) }} as unique_id
    from fields
)

select *
from final
