class TasksScreen
  include Frank::Cucumber::FrankHelper

  def self.with
    screen = self.new
    screen.wait_to_be_on_screen
    yield screen if block_given?
    screen
  end

  def wait_to_be_on_screen
    wait_for_element_to_exist( "view:'UINavigationItemButtonView' marked:'Lists'" )
  end

  def list_name_is(list_name)
    element_exists( "view:'UINavigationItemView' marked:'#{list_name}'" )
  end

  def task_text_field_is_first_responder
    results = frankly_map( "view:'CDIAddTaskView' view:'SSTextField'", 'isFirstResponder' )
    results.length == 1 && results.first == true
  end

  def has_task_list_of expected_task_list
    actual_task_list = frankly_map( "view:'CDITaskTableViewCell' view:'CDIAttributedLabel'", "text" )
    actual_task_list.sort == expected_task_list.sort
  end

  def task_text_field_resign_first_responder
    touch 'tableView'
  end

  def type_new_task_name( task_name )
    type_into_keyboard( task_name )
  end

end
