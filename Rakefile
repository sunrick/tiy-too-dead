require "bundler/gem_tasks"

# Now you can run migrations with `rake db:migrate`!
namespace :db do
  require_relative "lib/too_dead/init_db"

  desc "Run migrations"
  task :migrate do
    version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
    ActiveRecord::Migrator.migrate('db/migrate', version)
  end
end
