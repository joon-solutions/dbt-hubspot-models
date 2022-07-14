with source as (

    select * from {{ source('hubspot', 'engagement_meeting') }}

),

renamed as (

    select
        engagement_id,
        body,
        start_time,
        end_time,
        title,
        external_url,
        source,
        created_from_link_id,
        source_id,
        web_conference_meeting_id,
        meeting_outcome,
        pre_meeting_prospect_reminders,
        i_cal_uid,
        _fivetran_synced,
        location,
        meeting_change_id,
        calendar_event_hash,
        internal_meeting_notes,
        attendee_owner_ids

    from source

)

select * from renamed