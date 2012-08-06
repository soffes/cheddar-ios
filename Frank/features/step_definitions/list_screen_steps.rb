Given /^I am on the Lists screen$/ do
  ListScreen.new.wait_to_be_on_screen
end

When /^I choose to add a list called "(.*?)"$/ do |list_name|
  ListScreen.new.choose_to_add_a_list( list_name )
end
