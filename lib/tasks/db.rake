namespace :db do
  #task :dump do
    #`mysqldump -d -h localhost -u root xxx > db/structure.sql`
  #end

  task :environment do
    require 'app'
  end

  desc 'Output the schema to db/schema.rb'
  task :dump => :environment do
    ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, File.open('db/schema.rb', 'w'))
  end

  task :load => :environment do
    require './db/schema.rb'
  end

  task :seed => :environment do
    require 'db/seed'
  end
end
