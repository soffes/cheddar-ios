desc 'Setup private files so it will compile'
task :setup do
  # Update and initialize the submodules in case they forget
  `git submodule update --init --recursive`
  
  # Copy examples defines
  `cp Other\\ Sources/CDIDefinesExample.h Other\\ Sources/CDIDefines.h`
  `cp Other\\ Sources/CDIDefinesExample.m Other\\ Sources/CDIDefines.m`
  
  # Make placeholder fonts
  `mkdir -p Resources/Fonts`
  `touch Resources/Fonts/Gotham-Bold.otf`
  `touch Resources/Fonts/Gotham-BoldItalic.otf`
  `touch Resources/Fonts/Gotham-Book.otf`
  `touch Resources/Fonts/Gotham-BookItalic.otf`
end
