#$: << Dir.pwd

#Encoding.default_external = Encoding::UTF_8
#Encoding.default_internal = Encoding::UTF_8

#require './lib/configuration'
#require './lib/remember_errors'

require 'version'
require 'active_record'
require 'active_support/core_ext' 
require 'erb'
require 'logger'
require 'i18n'
require 'slim'
require 'coffee_script'
require 'tilt'

# Compass framework
require 'compass'
# Susy for responsive CSS grids
#require 'susy'
# Bootstrap with Sass
require 'bootstrap-sass'
# Sprockets for combining CSS and JS
require 'sprockets'
require 'sprockets-sass'

require 'pry'

require 'puma'
require 'yajl/json_gem'
require 'rack-flash'
require 'rack-cache'
require 'redcloth'
require 'sprockets'
require 'sinatra/base'
require 'sinatra/config_file'
require 'sinatra/activerecord'
require 'sinatra/content_for'
require 'sinatra/partial'
require 'sinatra/support/compasssupport'

# WillPaginate for pagination
require 'will_paginate'
require 'will_paginate/active_record'
require 'will_paginate/view_helpers/sinatra'

autoload_paths = %w(lib
app/concerns
app/helpers)

autoload_paths.each do |dir|
  Dir[File.join(dir, '**/*.rb')].each do |file|
    require_relative '../' + file
  end
end
