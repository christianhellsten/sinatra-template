# encoding: utf-8
#
# Asset pipeline (Sprockets)
#
namespace :assets do
  task :compile do
    version = Time.now.to_i 
    App.sprockets['application.js'].write_to("public/assets/application-#{version}.js")
    App.sprockets['application.css'].write_to("public/assets/application-#{version}.css")
    File.open('public/assets/version', 'w') { |f| f << version }
    puts "Done... Version #{version}"
  end
end
