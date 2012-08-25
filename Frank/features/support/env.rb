require 'frank-cucumber'

# UIQuery is deprecated. Please use the shelley selector engine. 
Frank::Cucumber::FrankHelper.use_shelley_from_now_on

# This constant must be set to the full, absolute path for your Frankified target's app bundle.
# See the "Given I launch the app" step definition in launch_steps.rb for more details
APP_BUNDLE_PATH = File.expand_path( '../../../frankified_build/Frankified.app', __FILE__ )
