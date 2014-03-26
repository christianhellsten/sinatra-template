require "sinatra/reloader"
App.register Sinatra::Reloader
App.also_reload 'app/**/*.rb'
App.also_reload 'lib/**/*.rb'
App.also_reload 'config/**/*.rb'
#disable :raise_errors
#disable :show_exceptions
require 'better_errors'
App.use BetterErrors::Middleware
BetterErrors.application_root = App.root
BetterErrors::Middleware.allow_ip! ENV['TRUSTED_IP'] if ENV['TRUSTED_IP']
