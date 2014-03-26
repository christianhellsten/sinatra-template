require 'settingslogic'
yml = YAML.load_file(File.join(App.root, "config/application.yml"))
conf = yml.fetch(App.environment.to_s) { fail "config/application.yml doesn't include #{App.environment}" }
Settings = Settingslogic.new(conf)

# NOTE: too much Sinatra magic overflow, blub
#class Settings < Settingslogic
  #source File.join(App.root, "config/application.yml")
  #namespace App.environment.to_sym
#end
