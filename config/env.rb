require "dm-core"
require 'dm-migrations'
#mysql:
auth = "root:#{File.read("/home/www-data/.password").strip}@" if ENV['RACK_ENV'] == "production"
DataMapper.setup(:default, "mysql://#{auth}localhost/sc2profiles_#{ENV['RACK_ENV']}")

#sqlite:
#DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/db/sc2profiles.sqlite")

# models
path = File.expand_path "../../", __FILE__
require "#{path}/models/profile"
require "#{path}/models/scraper"
require "#{path}/models/stats"

set :sessions, true