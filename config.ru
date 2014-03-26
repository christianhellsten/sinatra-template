#\ -s puma
require 'rubygems'
require 'bundler'

Bundler.require

require './app'

run Rack::URLMap.new(
  "/"           => HomeController.new,
  "/assets"     => App.sprockets
)
