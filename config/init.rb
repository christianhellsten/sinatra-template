autoload_paths = %w(config/initializers
app/models
app/mails/models
app/controllers
app/presenters
app/emails)

autoload_paths.each do |dir|
  Dir[File.join(dir, '**/*.rb')].each do |file|
    require_relative '../' + file
  end
end
