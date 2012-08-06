class ListScreen
  include Frank::Cucumber::FrankHelper

  def wait_to_be_on_screen
    # kind of a crappy way to tell if we're on the right screen, but it'll do for now
    wait_for_element_to_exist( "view:'UINavigationBar' view marked:'Cheddar'" )
  end

  def choose_to_add_a_list(list_name = false)
    touch "view:'UINavigationButton' marked:'plus'"
    type_new_list_name(list_name) if list_name
  end

  def type_new_list_name( list_name )
    type_into_keyboard( list_name )
  end

end
