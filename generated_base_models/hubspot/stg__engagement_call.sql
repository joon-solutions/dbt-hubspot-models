with source as (

    select * from {{ source('hubspot', 'engagement_call') }}

),

renamed as (

    select
        engagement_id,
        to_number,
        from_number,
        status,
        external_id,
        duration_milliseconds,
        external_account_id,
        recording_url,
        body,
        disposition,
        callee_object_type,
        callee_object_id,
        transcription_id,
        unknown_visitor_conversation,
        video_recording_url,
        source,
        title,
        _fivetran_synced,
        has_transcript,
        calls_service_call_id,
        direction

    from source

)

select * from renamed