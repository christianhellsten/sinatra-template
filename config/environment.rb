# LOGGING
unless ENV['run_rake']
  App.set :logging, false
  class ::Logger; alias_method :write, :<<; end
  if App.environment == :production
    FileUtils.mkdir_p(File.join(App.root, 'log'))
    logfile = File.join(App.root, 'log', "#{App.environment}.log")
    # Avoid truncation
    logfile = File.new(logfile, 'a+')
    logfile.sync = true
    log  = Logger.new(logfile, 'weekly')
    log.level = Logger::DEBUG
  else
    log = Logger.new(STDOUT)
  end
  App.set :log, log
end
Compass.add_project_configuration(File.join(Dir.pwd, 'config', 'compass.rb'))
