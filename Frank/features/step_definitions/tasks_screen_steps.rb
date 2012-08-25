Then /^I should be on the Tasks screen for the "(.*?)" list$/ do |list_name|
  TasksScreen.with do |screen|
    wait_until{ screen.list_name_is(list_name) }
  end
end

Then /^I should be prompted for my first task$/ do
  TasksScreen.with do |screen|
    wait_until{ screen.task_text_field_is_first_responder } 
  end
end

Then /^I should see a tasks list of:$/ do |table|
  expected_task_list = table.raw.flatten
  TasksScreen.with do |screen|
    wait_until{ screen.has_task_list_of( expected_task_list ) }
  end
end

When /^I enter a task name of "(.*?)"$/ do |task_name|
  TasksScreen.with do |screen|
    wait_until{ screen.task_text_field_is_first_responder } 
    screen.type_new_task_name( task_name )
  end
end

When /^I tap out of task entry mode$/ do
  TasksScreen.with do |screen|
    if screen.task_text_field_is_first_responder
      screen.task_text_field_resign_first_responder
    end
  end
end
