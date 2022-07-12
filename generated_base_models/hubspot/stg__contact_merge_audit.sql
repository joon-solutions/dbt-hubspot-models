with source as (

    select * from {{ source('hubspot', 'contact_merge_audit') }}

),

renamed as (

    select
        canonical_vid,
        contact_id,
        vid_to_merge,
        timestamp,
        merged_to_email_value,
        merged_to_email_timestamp,
        merged_to_email_selected,
        merged_to_email_source_type,
        merged_to_email_source_id,
        merged_to_email_source_label,
        merged_from_email_value,
        merged_from_email_timestamp,
        merged_from_email_selected,
        merged_from_email_source_vids,
        merged_from_email_source_type,
        merged_from_email_source_id,
        merged_from_email_source_label,
        entity_id,
        user_id,
        num_properties_moved,
        first_name,
        last_name,
        _fivetran_synced

    from source

)

select * from renamed