require './app'
root = "#{Dir.getwd}"
environment 'development'

#activate_control_app "tcp://0.0.0.0:3000"
bind "unix:///tmp/puma.pumatra.sock"
bind "tcp://0.0.0.0:8080"
pidfile "#{root}/tmp/pids/puma.pid"
rackup "#{root}/config.ru"
state_path "#{root}/tmp/pids/puma.state"
#stdout_redirect "./log/#{App.environment}.log", "./log/#{App.environment}.log", true
