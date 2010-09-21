require "dm-core"
require 'dm-migrations'
#mysql:
DataMapper.setup(:default, "mysql://#{"root:#{File.read("/home/www-data/.password").strip}@" if ENV['RACK_ENV'] == "production"}localhost/sc2profiles_dev")

#sqlite:
#DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/db/sc2profiles.sqlite")

# models
path = File.expand_path "../../", __FILE__
require "#{path}/models/profile"
require "#{path}/models/scraper"
require "#{path}/models/stats"