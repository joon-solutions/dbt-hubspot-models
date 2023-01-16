{% snapshot salesforce__opportunity_snapshot %}

    {{
        config(
          unique_key='id',
          strategy='timestamp',
          updated_at='system_modstamp',
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