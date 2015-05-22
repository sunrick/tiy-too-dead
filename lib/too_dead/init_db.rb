require 'active_record'
require 'yaml'

# require this file when your program starts so you can use the database

config_path = 'config/database.yml'
db_config = YAML::load(File.open(config_path))
ActiveRecord::Base.establish_connection(db_config)
