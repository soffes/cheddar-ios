Given /^I am on the Lists screen$/ do
  # kind of a crappy way to tell if we're on the right screen, but it'll do for now
  wait_for_element_to_exist( "view:'UINavigationBar' view marked:'Cheddar'" )
end

When /^I choose to add a list called "(.*?)"$/ do |list_name|
  touch "view:'UINavigationButton' marked:'plus'"
  type_into_keyboard( list_name )
end
