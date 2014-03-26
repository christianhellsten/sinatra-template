#
# http://nadarei.co/mina
# http://nadarei.co/mina/tasks
# http://nadarei.co/mina/settings
# http://nadarei.co/mina/helpers
#
require 'mina/bundler'
require 'mina/rails'
require 'mina/whenever'
# http://nadarei.co/mina/docs/lib/mina/rbenv.html
require 'mina/rbenv'
require 'mina/git'

set :sudo, true
set :term_mode, :system
set :rails_env, "production"
#set :port, 5000
set :user, 'dev'

require_relative '../app'

set :repository, Settings.deployment.domain
set :domain,    Settings.deployment.domain
set :deploy_to, Settings.deployment.deploy_to
set :rails_env, Settings.deployment.environment
set :puma_pid,  Settings.deployment.pid
set :shared_paths, Settings.deployment.shared_paths
set :full_current_path, "#{deploy_to}/#{current_path}"
set :full_shared_path, "#{deploy_to}/#{shared_path}"

task :environment do
  invoke :'rbenv:load'
end

task :deploy => :environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    #invoke :'whenever:update'
    invoke :'deploy:cleanup'
    to :launch do
      invoke :'assets:compile'
      invoke :'db:migrate'
      #invoke 'cache:clear'
      invoke 'puma:restart'
      # https://github.com/stouset/version
      %x[rake version:bump]
    end
  end
end

def rake(cmd)
  queue! "cd #{deploy_to!}/current && RACK_ENV=#{settings.rails_env} bundle exec rake #{cmd} --trace"
end

namespace :search do
  task :reindex => :environment do
    rake 'search:reindex'
  end
end

namespace :assets do
  task :compile => :environment do
    rake 'assets:precompile'
  end
end

namespace :db do
  task :migrate => :environment do
    rake 'db:migrate'
  end

  task :create => :environment do
    rake 'db:create'
  end
end

def puma_conf
  @puma_conf ||= begin
    require 'puma/configuration'
    config = Puma::Configuration.new(config_file: "config/puma.rb.#{rails_env}")
    config.load
    OpenStruct.new(config.options)
  end
end

set :puma_cmd, "RAILS_ENV=#{rails_env} bundle exec puma"
set :pumactl_cmd, "RAILS_ENV=#{rails_env} bundle exec pumactl -F config/puma/#{rails_env}.rb"
#set :puma_state_path, puma_conf.state
set :puma_start_options, "-q -d -e #{rails_env} -C config/puma/#{rails_env}.rb"

# See https://github.com/puma/puma/blob/master/lib/puma/capistrano.rb
namespace :puma do
  desc 'Start puma'
  task :start => :environment do
    queue "cd #{full_current_path} && #{puma_cmd} #{puma_start_options}"
  end

  desc 'Stop puma'
  task :stop => :environment do
    queue "cd #{full_current_path} && #{pumactl_cmd} stop"
  end

  desc 'Puma status'
  task :status => :environment do
    queue "cd #{full_current_path} && #{pumactl_cmd} status"
  end

  # NOTE: this shit doens't work. if puma isn't running, it starts the
  # server in development mode. Assholes.
  desc 'Restart puma'
  task :restart => :environment do
    begin
      queue "cd #{full_current_path} && #{pumactl_cmd} restart"
    rescue => ex
      puts "Failed to restart puma: #{ex}\nAssuming not started."
    end
  end

  # FIXME: doesn't work when Puma is not running. starts app in dev
  # mode... bug in pumactl
  desc 'Restart puma (phased restart)'
  task :phased_restart => :environment do
    run "cd #{full_current_path} && #{pumactl_cmd} phased-restart"
  end
end

namespace :cache do
  task :clear => :environment do
    queue! "cd #{deploy_to!}/#{current_path!} && rm -rf tmp/cache"
    puts "Rack cache cleared"
  end
end

desc "Shows logs."
task :logs do
  queue %[cd #{deploy_to!} && tail -f shared/log/#{settings.rails_env}.log]
end
