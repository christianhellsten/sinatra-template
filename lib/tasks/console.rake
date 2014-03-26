require 'pry'

task :console do
  puts "Starting console"
  $VERBOSE = nil
  binding.pry
end
