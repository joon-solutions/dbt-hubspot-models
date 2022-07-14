with source as (

    select * from {{ source('hubspot', 'ticket') }}

),

renamed as (

    select
        id,
        portal_id,
        object_type,
        is_deleted,
        _fivetran_synced,
        property_hs_pipeline_stage,
        property_hs_auto_generated_from_thread_id,
        property_subject,
        property_hs_last_email_date,
        property_hs_num_times_contacted,
        property_hs_conversations_originating_message_id,
        property_createdate,
        property_hs_lastmodifieddate,
        property_hs_last_email_activity,
        property_hs_lastcontacted,
        property_hs_pipeline,
        property_content,
        property_hs_lastactivitydate,
        property_last_reply_date,
        property_source_type,
        property_hs_originating_email_engagement_id,
        property_created_by,
        property_hs_conversations_originating_thread_id,
        property_num_notes,
        property_time_to_close,
        property_closed_date,
        property_notes_last_updated,
        property_first_agent_reply_date,
        property_notes_last_contacted,
        property_hs_updated_by_user_id,
        property_hubspot_owner_assigneddate,
        property_hs_sales_email_last_replied,
        property_num_contacted_notes,
        property_hubspot_owner_id,
        property_hs_user_ids_of_all_owners,
        property_time_to_first_agent_reply,
        property_last_engagement_date,
        property_hs_all_owner_ids,
        property_hs_created_by_user_id,
        property_hs_merged_object_ids,
        property_hs_ticket_priority,
        property_parent_organization,
        property_organization,
        property_email_id,
        property_first_name,
        property_last_name,
        property_hs_ticket_category,
        property_hs_external_object_ids,
        property_asana_id,
        property_hs_nextactivitydate,
        property_notes_next_activity_date,
        property_hs_file_upload,
        property_hs_thread_ids_to_restore,
        property_hubspot_team_id,
        property_hs_all_team_ids,
        property_hs_all_accessible_team_ids,
        property_course_impacted

    from source

)

select * from renamed