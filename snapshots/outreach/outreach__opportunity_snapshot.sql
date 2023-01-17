{% snapshot outreach__opportunity_snapshot %}

    {{
        config(
          unique_key='opportunity_id',
          strategy='timestamp',
          updated_at='updated_at',
        )
    }}

    select 
      {{ dbt_utils.surrogate_key(['id','updated_at']) }} as opportunity_id_scd,
      {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('outreach', 'opportunity')),
                staging_columns = get_staging_outreach_opportunity_columns()
            )

        }}

    from  {{ source('outreach','opportunity') }}

{% endsnapshot %}