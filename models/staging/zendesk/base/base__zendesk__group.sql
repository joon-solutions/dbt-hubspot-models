with base as (

    select *
    from {{ ref('base__zendesk__group_tmp') }}

),


fields as (

    select

        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('base__zendesk__group_tmp')),
                staging_columns=get_zendesk_group_columns()
            )
        }}

    from base
),

final as (

    select
        group_id,
        group_name
    from fields

    where not coalesce(_fivetran_deleted, false)
)

select *
from final
