{% snapshot salesforce__opportunity_snapshot %}

    {{
        config(
          unique_key='opportunity_id',
          strategy='timestamp',
          updated_at='updated_at',
        )
    }}

    select 
      {{ dbt_utils.surrogate_key(['id','system_modstamp']) }} as opportunity_id_scd,
      {{
            fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(source('salesforce', 'opportunity')),
                staging_columns = get_salesforce_opportunity_columns()
            )
        }}
      
    from {{ source('salesforce', 'opportunity') }}

{% endsnapshot %}