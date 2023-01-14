{% snapshot outreach_opportunity_snapshot %}

    {{
        config(
          target_schema='snapshots',
          unique_key='opportunity_id',
          strategy='timestamp',
          updated_at='updated_at',
        )
    }}

    select * from {{ ref('stg__outreach__opportunity') }}

{% endsnapshot %}