  # let's be nice and not force people to install testing infrastructure if they don't want to
begin require 'cucumber/rake/task' rescue LoadError nil end

class String
  def self.colorize(text, color_code)
    "\e[#{color_code}m#{text}\e[0m"
  end
  
  def cyan
    self.class.colorize(self, 36)
  end

  def green
    self.class.colorize(self, 32)
  end
end

desc 'Setup with example files and dummy fonts'
task :setup do
  # Update and initialize the submodules in case they forget
  puts 'Updating submodules...'.cyan
  `git submodule update --init --recursive`
  
  # Copy examples defines
  puts 'Copying example CDIDefines into place...'.cyan
  `cp Other\\ Sources/CDIDefinesExample.h Other\\ Sources/CDIDefines.h`
  `cp Other\\ Sources/CDIDefinesExample.m Other\\ Sources/CDIDefines.m`
  
  # Make placeholder fonts
  puts 'Creating dummy fonts...'.cyan
  `mkdir -p Resources/Fonts`
  `touch Resources/Fonts/Gotham-Bold.otf`
  `touch Resources/Fonts/Gotham-BoldItalic.otf`
  `touch Resources/Fonts/Gotham-Book.otf`
  `touch Resources/Fonts/Gotham-BookItalic.otf`
  
  # Done!
  puts 'Done! You\'re ready to get started!'.green
end

# Run setup by default
task :default => :setup


desc 'Setup with private files'
task :'setup:private' do
  # Update and initialize the submodules in case they forget
  puts 'Updating submodules...'.cyan
  `git submodule update --init --recursive`
  
  # Copy defines
  puts 'Copying example CDIDefines into place...'.cyan
  `cp ../cheddar-private/iOS/CDIDefines.* Other\\ Sources/`
  
  # Make placeholder fonts
  puts 'Coping Gotham...'.cyan
  `cp -R ../cheddar-private/Resources/Fonts Resources/`
  
  # Done!
  puts 'Done! You\'re ready to get started!'.green
end

if defined? Cucumber
  desc 'build a Frankified version of the app for acceptance testing'
  task 'acceptance_build' do
    sh 'frank build'
  end

  Cucumber::Rake::Task.new(:acceptance_without_build, 'Run Frank acceptance tests') do |t|
    t.cucumber_opts = "Frank/features"
  end

  desc "rebuild app and run acceptance tests. Use acceptance_without_build if you'd like to skip the rebuild part."
  task 'acceptance' => %w{acceptance_build acceptance_without_build}
end
