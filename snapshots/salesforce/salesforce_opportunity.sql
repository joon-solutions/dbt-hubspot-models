{% snapshot salesforce_opportunity_snapshot %}

    {{
        config(
          unique_key='opportunity_id',
          strategy='timestamp',
          updated_at='updated_at',
        )
    }}

    select * from {{ ref('stg__salesforce__opportunity') }}

{% endsnapshot %}