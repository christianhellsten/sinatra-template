# Rakefile
ENV['run_rake'] = 'true'
require 'bundler/setup'
require './app'
require 'sprockets'
require 'sinatra/activerecord/rake'
require 'rake/version_task'

# https://github.com/stouset/version
Rake::VersionTask.new do |task|
  task.with_git_tag = true
end

task :environment do
end

namespace :deploy do
  desc 'Deploy to staging environment'
  task :staging do
    exec 'mina deploy to=staging'
  end
end

task :deploy do
  exec 'mina deploy'
end

Dir['lib/tasks/**/*.rake'].each do |file|
  import file
end
