Then /^I should be on the Tasks screen for the "(.*?)" list$/ do |list_name|
  wait_for_element_to_exist( "view:'UINavigationItemButtonView' marked:'Lists'" )
  check_element_exists( "view:'UINavigationItemView' marked:'#{list_name}'" )
end

Then /^I should be prompted for my first task$/ do
  wait_until do
    results = frankly_map( "view:'CDIAddTaskView' view:'SSTextField'", 'isFirstResponder' )
    results.length == 1 && results.first == true
  end
end

Then /^I should see a tasks list of:$/ do |table|
  expected_task_list = table.raw.flatten
  actual_task_list = frankly_map( "view:'CDITaskTableViewCell' view:'CDIAttributedLabel'", "text" )
  expected_task_list.should =~ actual_task_list
end

When /^I enter a task name of "(.*?)"$/ do |task_name|
  wait_until do
    results = frankly_map( "view:'CDIAddTaskView' view:'SSTextField'", 'isFirstResponder' )
    results.length == 1 && results.first == true
  end

  type_into_keyboard( task_name )

  # ACK! Need a better way to wait for the transition animation to end. maybe something like 'wait_for_animation_within_container_to_finish'?
  sleep 1
end

When /^I tap out of task entry mode$/ do
  touch 'tableView'
end

