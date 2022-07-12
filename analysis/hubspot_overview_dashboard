- dashboard: hubspot_overview
  title: Hubspot Overview
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - title: Conversion Rate, All Campaigns
    name: Conversion Rate, All Campaigns
    model: block_hubspot_marketing_v2
    explore: contact
    type: single_value
    fields: [contact_form_submission.conversion_rate]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen:
      Date: email_event.created_date
    row: 0
    col: 12
    width: 6
    height: 4
  - title: Campaign Event Rates
    name: Campaign Event Rates
    model: block_hubspot_marketing_v2
    explore: contact
    type: looker_area
    fields: [email_event.created_month, contact_form_submission.conversion_rate, email_event_open.opened_pct,
      email_event_delivered.delivered_pct]
    fill_fields: [email_event.created_month]
    sorts: [email_event.created_month desc]
    limit: 500
    column_limit: 50
    x_axis_gridlines: true
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: false
    interpolation: linear
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    series_colors:
      sent: "#E57947"
      delivered: "#FBB555"
      opened: "#E57947"
      conversion_rate: "#4276BE"
      email_event_delivered.delivered_pct: "#E57947"
      email_event_open.opened_pct: "#FBB555"
      contact_form_submission.conversion_rate: "#4276BE"
    series_point_styles:
      conversion_rate: diamond
    swap_axes: false
    discontinuous_nulls: true
    ordering: none
    show_null_labels: false
    defaults_version: 1
    hidden_fields:
    listen:
      Date: email_event.created_date
    row: 4
    col: 12
    width: 12
    height: 9
  - title: Campaigns
    name: Campaigns
    model: block_hubspot_marketing_v2
    explore: contact
    type: single_value
    fields: [email_campaign.count]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    hidden_fields:
    listen:
      Date: email_event.created_date
    row: 0
    col: 0
    width: 6
    height: 4
  - title: Open Rate, All Campaigns
    name: Open Rate, All Campaigns
    model: block_hubspot_marketing_v2
    explore: contact
    type: single_value
    fields: [email_event_open.opened_pct]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    hidden_fields:
    listen:
      Date: email_event.created_date
    row: 0
    col: 6
    width: 6
    height: 4
  - title: Contacts
    name: Contacts
    model: block_hubspot_marketing_v2
    explore: contact
    type: single_value
    fields: [email_campaign.count]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    hidden_fields:
    listen:
      Date: email_event.created_date
    row: 0
    col: 18
    width: 6
    height: 4
  - title: Event Occurrence by Touch
    name: Event Occurrence by Touch
    model: block_hubspot_marketing_v2
    explore: contact
    type: looker_column
    fields: [sequences.touch_sequence, email_event_delivered.count, email_event_dropped.count,
      email_event_open.count, contact_form_submission.conversion_rate]
    filters:
      sequences.touch_sequence: NOT NULL
    sorts: [email_event_delivered.count desc]
    limit: 500
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: circle
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: email_event_delivered.count,
            id: email_event_delivered.count, name: Delivered Count}, {axisId: email_event_dropped.count,
            id: email_event_dropped.count, name: Dropped Count}, {axisId: email_event_open.count,
            id: email_event_open.count, name: Opened Count}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear},
      {label: !!null '', orientation: right, series: [{axisId: contact_form_submission.conversion_rate,
            id: contact_form_submission.conversion_rate, name: Conversion Rate}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    series_types:
      contact_form_submission.conversion_rate: line
    series_colors:
      email_event_dropped.count: "#FBB555"
      email_event_open.count: "#E57947"
      email_event_delivered.count: "#fad295"
      contact_form_submission.conversion_rate: "#4276BE"
    defaults_version: 1
    listen:
      Date: email_event.created_date
    row: 4
    col: 0
    width: 12
    height: 9
  - title: Opened Rate, Largest Campaigns
    name: Opened Rate, Largest Campaigns
    model: block_hubspot_marketing_v2
    explore: contact
    type: looker_pie
    fields: [email_event_open.opened_pct, email_campaign.name, email_event_sent.count]
    filters:
      email_campaign.name: "-NULL"
    sorts: [email_event_sent.count desc]
    limit: 10
    query_timezone: America/Los_Angeles
    value_labels: labels
    label_type: labVal
    inner_radius: 40
    color_application:
      collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
      palette_id: 1e4d66b9-f066-4c33-b0b7-cc10b4810688
      options:
        steps: 5
        reverse: false
    series_colors: {}
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    series_types: {}
    hidden_fields: [email_event_sent.count]
    listen:
      Date: email_event.created_date
    row: 13
    col: 0
    width: 8
    height: 8
  - title: Emails this Year
    name: Emails this Year
    model: block_hubspot_marketing_v2
    explore: contact
    type: looker_column
    fields: [email_event_sent.count, email_event_delivered.count, email_event_open.count]
    limit: 500
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_colors:
      sent: "#E57947"
      delivered: "#FBB555"
      opened: "#4276BE"
      email_event_sent.count: "#E57947"
      email_event_delivered.count: "#FBB555"
      email_event_open.count: "#4276BE"
    series_labels:
      email_event_sent.count: Sent
      email_event_delivered.count: Delivered
      email_event_open.count: Opened
    show_dropoff: true
    defaults_version: 1
    hidden_fields:
    listen:
      Date: email_event.created_date
    row: 13
    col: 8
    width: 8
    height: 8
  - title: Conversions over Time
    name: Conversions over Time
    model: block_hubspot_marketing_v2
    explore: contact
    type: looker_area
    fields: [email_event.created_date, contact_form_submission.conversions]
    fill_fields: [email_event.created_date]
    sorts: [email_event.created_date]
    limit: 500
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: false
    interpolation: step
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: Conversions, orientation: left, series: [{axisId: contact_form_submission.conversions,
            id: contact_form_submission.conversions, name: Conversions}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    series_types: {}
    series_colors:
      running_total_conversions: "#E57947"
      running_total_contacts: "#4276BE"
      count_of_conversion_id: "#E57947"
      contact_form_submission.conversions: "#E57947"
    swap_axes: false
    discontinuous_nulls: false
    defaults_version: 1
    hidden_fields: []
    ordering: none
    show_null_labels: false
    listen:
      Date: email_event.created_date
    row: 13
    col: 16
    width: 8
    height: 4
  - title: Contacts over Time
    name: Contacts over Time
    model: block_hubspot_marketing_v2
    explore: contact
    type: looker_area
    fields: [email_event.created_date, contact.count]
    fill_fields: [email_event.created_date]
    sorts: [email_event.created_date]
    limit: 500
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: false
    interpolation: step
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: Contacts, orientation: left, series: [{axisId: contact.count,
            id: contact.count, name: Contact}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    series_types: {}
    series_colors:
      running_total_conversions: "#E57947"
      running_total_contacts: "#4276BE"
      count_of_conversion_id: "#E57947"
      contact.count: "#4276BE"
    swap_axes: false
    discontinuous_nulls: false
    defaults_version: 1
    hidden_fields: []
    ordering: none
    show_null_labels: false
    listen:
      Date: email_event.created_date
    row: 17
    col: 16
    width: 8
    height: 4
  - title: Campaign Clicks by Count of Reported Spam
    name: Campaign Clicks by Count of Reported Spam
    model: block_hubspot_marketing_v2
    explore: contact
    type: looker_scatter
    fields: [email_campaign.id, email_event_click.count, email_event_spam_report.count,
      email_event_sent.count]
    sorts: [email_event_spam_report.count desc]
    limit: 500
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: circle
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    size_by_field: email_event_sent.count
    series_types: {}
    series_colors:
      email_event_click.count: "#E57947"
      email_event_sent.count: "#E57947"
      click_count: "#E57947"
    trend_lines: []
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    hidden_fields: [email_campaign.id]
    listen:
      Date: email_event.created_date
    row: 21
    col: 0
    width: 12
    height: 12
  - title: Conversion Activity Heatmap
    name: Conversion Activity Heatmap
    model: block_hubspot_marketing_v2
    explore: contact
    type: looker_grid
    fields: [contact_form_submission.timestamp_hour_of_day, contact_form_submission.timestamp_day_of_week,
      contact_form_submission.count]
    pivots: [contact_form_submission.timestamp_day_of_week]
    fill_fields: [contact_form_submission.timestamp_day_of_week, contact_form_submission.timestamp_hour_of_day]
    sorts: [contact_form_submission.timestamp_day_of_week 0, contact_form_submission.timestamp_hour_of_day]
    limit: 500
    column_limit: 50
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_cell_visualizations:
      contact_form_submission.count:
        is_active: false
    conditional_formatting: [{type: along a scale..., value: 0, background_color: "#3EB0D5",
        font_color: !!null '', color_application: {collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7,
          custom: {id: 5094673f-e4b4-c356-8fab-0c77880e23c6, label: Custom, type: continuous,
            stops: [{color: "#E57947", offset: 0}, {color: "#FBB555", offset: 25},
              {color: "#fff", offset: 50}, {color: "#3EB0D5", offset: 75}, {color: "#4276BE",
                offset: 100}]}, options: {steps: 5, constraints: {min: {type: minimum},
              mid: {type: number, value: 0}, max: {type: maximum}}, mirror: true,
            reverse: true, stepped: false}}, bold: false, italic: false, strikethrough: false,
        fields: [contact_form_submission.count]}]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    series_types: {}
    listen:
      Date: email_event.created_date
    row: 21
    col: 12
    width: 12
    height: 12
  filters:
  - name: Date
    title: Date
    type: date_filter
    default_value: ''
    allow_multiple_values: true
    required: false