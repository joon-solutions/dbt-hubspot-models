- dashboard: subscriptions_overview
  title: Subscriptions Overview
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - title: Subscription Event Flow
    name: Subscription Event Flow
    model: block_hubspot_marketing_v2
    explore: contact
    type: looker_column
    fields: [email_subscription_change.timestamp_month, email_subscription.count,
      email_subscription_change.change]
    pivots: [email_subscription_change.change]
    fill_fields: [email_subscription_change.timestamp_month]
    filters:
      email_subscription.active: 'Yes'
      email_subscription_change.change: SUBSCRIBED,UNSUBSCRIBED
    sorts: [email_subscription_change.timestamp_month, email_subscription_change.change
        0]
    limit: 500
    column_limit: 50
    dynamic_fields: [{table_calculation: net_subscriptions, label: Net Subscriptions,
        expression: 'running_total(coalesce(pivot_where(${email_subscription_change.change}=
          "SUBSCRIBED", ${email_subscription.count}),0)-coalesce(pivot_where(${email_subscription_change.change}=
          "UNSUBSCRIBED", ${email_subscription.count}),0))', value_format: !!null '',
        value_format_name: !!null '', _kind_hint: supermeasure, _type_hint: number},
      {table_calculation: unsubscribe_events, label: Unsubscribe Events, expression: 'coalesce(-1*pivot_where(${email_subscription_change.change}="UNSUBSCRIBED",
          ${email_subscription.count}), 0)', value_format: !!null '', value_format_name: !!null '',
        _kind_hint: supermeasure, _type_hint: number}, {table_calculation: subscribe_events,
        label: Subscribe Events, expression: 'coalesce(pivot_where(${email_subscription_change.change}="SUBSCRIBED",
          ${email_subscription.count}), 0)', value_format: !!null '', value_format_name: !!null '',
        _kind_hint: supermeasure, _type_hint: number}]
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
    series_types:
      subscriptions: line
      net_subscriptions: line
    series_colors:
      subscribe_events: "#4276BE"
      unsubscribe_events: "#E57947"
      net_subscriptions: "#75E2E2"
    show_null_points: true
    interpolation: linear
    discontinuous_nulls: false
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
    hidden_fields: [email_subscription.count]
    listen:
      Date: email_subscription_change.timestamp_date
    row: 3
    col: 0
    width: 24
    height: 10
  - title: Unsubscribe Events
    name: Unsubscribe Events
    model: block_hubspot_marketing_v2
    explore: contact
    type: single_value
    fields: [email_subscription_change.count_unsubscribe_events, email_subscription_change.count_spam_report_events,
      email_subscription_change.count_subscribe_events]
    limit: 500
    query_timezone: America/Los_Angeles
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
    hidden_fields: [email_subscription_change.count_spam_report_events, email_subscription_change.count_subscribe_events]
    listen:
      Date: email_subscription_change.timestamp_date
    row: 0
    col: 6
    width: 6
    height: 3
  - title: Emails Reported as Spam
    name: Emails Reported as Spam
    model: block_hubspot_marketing_v2
    explore: contact
    type: single_value
    fields: [email_subscription_change.count_unsubscribe_events, email_subscription_change.count_spam_report_events,
      email_subscription_change.count_subscribe_events]
    limit: 500
    query_timezone: America/Los_Angeles
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
    hidden_fields: [email_subscription_change.count_subscribe_events, email_subscription_change.count_unsubscribe_events]
    listen:
      Date: email_subscription_change.timestamp_date
    row: 0
    col: 12
    width: 6
    height: 3
  - title: Subscribe Events
    name: Subscribe Events
    model: block_hubspot_marketing_v2
    explore: contact
    type: single_value
    fields: [email_subscription_change.count_unsubscribe_events, email_subscription_change.count_spam_report_events,
      email_subscription_change.count_subscribe_events]
    limit: 500
    query_timezone: America/Los_Angeles
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
    hidden_fields: [email_subscription_change.count_unsubscribe_events, email_subscription_change.count_spam_report_events]
    listen:
      Date: email_subscription_change.timestamp_date
    row: 0
    col: 0
    width: 6
    height: 3
  - title: Best Performing Campaigns (Net Subscriptions)
    name: Best Performing Campaigns (Net Subscriptions)
    model: block_hubspot_marketing_v2
    explore: contact
    type: looker_grid
    fields: [email_campaign.name, email_subscription_change.net_subscription_events,
      email_subscription_change.count_subscribe_events, email_subscription_change.count_unsubscribe_events]
    sorts: [email_subscription_change.net_subscription_events desc]
    limit: 500
    column_limit: 50
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: false
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_labels:
      email_campaign.name: Campaign Name
      email_subscription_change.count_unsubscribe_events: Unsubscribe Events
      email_subscription_change.count_subscribe_events: Subscribe Events
      email_subscription_change.net_subscription_events: Net New Subscriptions
    series_column_widths:
      email_campaign.name: 273
      email_subscription_change.net_subscription_events: 200
      email_subscription_change.count_subscribe_events: 165
      email_subscription_change.count_unsubscribe_events: 151
    series_cell_visualizations:
      email_subscription_change.count_subscribe_events:
        is_active: false
        palette:
          palette_id: 1e4d66b9-f066-4c33-b0b7-cc10b4810688
          collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
      email_subscription_change.count_unsubscribe_events:
        is_active: false
        palette:
          palette_id: 255c63a6-6b3a-ad00-7d06-b0660194a82f
          collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
          custom_colors:
          - "#4276BE"
          - "#3EB0D5"
          - "#ffffff"
          - "#FBB555"
          - "#E57947"
      email_subscription_change.net_subscription_events:
        is_active: true
        palette:
          palette_id: 1e4d66b9-f066-4c33-b0b7-cc10b4810688
          collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
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
    hidden_fields:
    show_null_points: true
    listen:
      Date: contact_form_submission.timestamp_date
    row: 13
    col: 0
    width: 12
    height: 8
  - title: Worst Performing Campaigns (Net Subscriptions)
    name: Worst Performing Campaigns (Net Subscriptions)
    model: block_hubspot_marketing_v2
    explore: contact
    type: looker_grid
    fields: [email_campaign.name, email_subscription_change.net_subscription_events,
      email_subscription_change.count_subscribe_events, email_subscription_change.count_unsubscribe_events]
    sorts: [email_subscription_change.net_subscription_events]
    limit: 500
    column_limit: 50
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: false
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_labels:
      email_campaign.name: Campaign Name
      email_subscription_change.count_unsubscribe_events: Unsubscribe Events
      email_subscription_change.count_subscribe_events: Subscribe Events
      email_subscription_change.net_subscription_events: Net New Subscriptions
    series_column_widths:
      email_campaign.name: 273
      email_subscription_change.net_subscription_events: 200
      email_subscription_change.count_subscribe_events: 165
      email_subscription_change.count_unsubscribe_events: 151
    series_cell_visualizations:
      email_subscription_change.count_subscribe_events:
        is_active: false
        palette:
          palette_id: 1e4d66b9-f066-4c33-b0b7-cc10b4810688
          collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
      email_subscription_change.count_unsubscribe_events:
        is_active: false
        palette:
          palette_id: 255c63a6-6b3a-ad00-7d06-b0660194a82f
          collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
          custom_colors:
          - "#4276BE"
          - "#3EB0D5"
          - "#ffffff"
          - "#FBB555"
          - "#E57947"
      email_subscription_change.net_subscription_events:
        is_active: true
        palette:
          palette_id: 1e4d66b9-f066-4c33-b0b7-cc10b4810688
          collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
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
    hidden_fields:
    show_null_points: true
    listen:
      Date: contact_form_submission.timestamp_date
    row: 13
    col: 12
    width: 12
    height: 8
  - title: Subscription Changes by Campaign Type
    name: Subscription Changes by Campaign Type
    model: block_hubspot_marketing_v2
    explore: contact
    type: looker_column
    fields: [email_subscription_change.count, email_subscription_change.change, email_campaign.type]
    pivots: [email_subscription_change.change]
    sorts: [email_subscription_change.change 0, email_subscription_change.count desc
        0]
    limit: 500
    dynamic_fields: [{dimension: positivenegative, label: Positive/Negative, expression: 'if(${email_subscription_change.change}
          = "CLEARED_SPAM_REPORT" OR ${email_subscription_change.change} = "SUBSCRIBED",
          concat(${email_campaign.type}, " "), replace(${email_campaign.type}, ${email_campaign.type},
          "-"))', value_format: !!null '', value_format_name: !!null '', _kind_hint: dimension,
        _type_hint: string}, {table_calculation: change_type_count, label: Change
          Type Count, expression: 'if(${email_subscription_change.change} = "CLEARED_SPAM_REPORT"
          OR ${email_subscription_change.change} = "SUBSCRIBED", ${email_subscription_change.count},
          -1*${email_subscription_change.count})', value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, _type_hint: number}]
    query_timezone: America/Los_Angeles
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
    y_axes: [{label: '', orientation: left, series: [{axisId: CLEARED_SPAM_REPORT
              - email_subscription_change.count, id: CLEARED_SPAM_REPORT - email_subscription_change.count,
            name: CLEARED_SPAM_REPORT}, {axisId: REPORTED_SPAM - email_subscription_change.count,
            id: REPORTED_SPAM - email_subscription_change.count, name: REPORTED_SPAM},
          {axisId: SUBSCRIBED - email_subscription_change.count, id: SUBSCRIBED -
              email_subscription_change.count, name: SUBSCRIBED}, {axisId: UNSUBSCRIBED
              - email_subscription_change.count, id: UNSUBSCRIBED - email_subscription_change.count,
            name: UNSUBSCRIBED}], showLabels: false, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    hide_legend: false
    font_size: '12'
    trellis_rows: 1
    series_types: {}
    series_colors:
      UNSUBSCRIBED - email_subscription_change.count: "#E57947"
      SUBSCRIBED - email_subscription_change.count: "#4276BE"
      CLEARED_SPAM_REPORT - email_subscription_change.count: "#75E2E2"
      REPORTED_SPAM - email_subscription_change.count: "#FBB555"
      REPORTED_SPAM - change_type_count: "#FBB555"
      UNSUBSCRIBED - change_type_count: "#E57947"
      SUBSCRIBED - change_type_count: "#4276BE"
    column_group_spacing_ratio: 0.1
    show_null_points: true
    interpolation: linear
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
    hidden_fields: [email_subscription_change.count]
    note_state: collapsed
    note_display: hover
    note_text: Desired changes are positive, unfavorable changes are negative.
    listen:
      Date: email_subscription_change.timestamp_date
    row: 21
    col: 0
    width: 24
    height: 10
  - title: Total Subscribers
    name: Total Subscribers
    model: block_hubspot_marketing_v2
    explore: contact
    type: single_value
    fields: [email_subscription.count]
    limit: 500
    column_limit: 50
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
    listen: {}
    row: 0
    col: 18
    width: 6
    height: 3
  filters:
  - name: Date
    title: Date
    type: date_filter
    default_value: 3 months
    allow_multiple_values: true
    required: false
