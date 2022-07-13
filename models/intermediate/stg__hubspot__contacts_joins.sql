with contact as (

    select *
    from {{ ref('base__hubspot__contact') }}

),

contact_list_member as (

    select *
    from {{ ref('base__hubspot__contact_list_member') }}

),

contact_list as (

    select *
    from {{ ref('base__hubspot__contact_list') }}

),

final as (

    select
        contact.contact_id,
        contact_list_member.contact_list_id, ---FK to contact_list: Looker layer
        contact.contact_email,
        contact.contact_name,
        contact.contact_address,
        contact.contact_city,
        contact.contact_country,
        contact.analytics_source,
        contact.contact_job_title,
        contact.contact_company,
        coalesce(contact.property_phone, contact.property_mobilephone) as contact_phone
        ---to-add-more when needed
    from contact
    left join contact_list_member on contact.contact_id = contact_list_member.contact_id ---one-to-man

)

select * from final
