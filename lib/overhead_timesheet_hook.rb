class OverheadTimesheetHook < Redmine::Hook::ViewListener
  include OverheadHelper

  # Adds a table header "Billable" to the report results
  def plugin_timesheet_views_timesheet_group_header(context={})
    return content_tag(:th, l(:overhead_field_billable))
  end

  # Adds a blank table cell to the issue grouping option
  def plugin_timesheet_views_timesheet_time_entry_sum(context={})
    return content_tag(:td, '')
  end
  
  # Adds the gree checkbox image if the TimeEntry is billable
  def plugin_timesheet_views_timesheet_time_entry(context={})
    time_entry = context[:time_entry]
    if time_entry && time_entry.billable? 
      content_tag(:td, image_tag('true.png'), :style => "text-align:center;")
    else 
      content_tag(:td,'') 
    end 
  end

  # Added a new field for filtering based on "billable?"
  def plugin_timesheet_views_timesheet_form(context={})
    billable_values = select_values_for_field(TimeEntryActivity.billable_custom_field)
    if context[:params] &&
        context[:params][:timesheet] &&
        context[:params][:timesheet][:billable]
      selected_values = context[:params][:timesheet][:billable]
    else
      selected_values = []
    end

    context[:controller].send(:render_to_string,
                              :partial => 'timesheet/overhead_form',
                              :layout => false,
                              :locals => {
                                :list_size => context[:list_size] || 5,
                                :billable_values => billable_values,
                                :selected_values => selected_values
                              })
  end
end
