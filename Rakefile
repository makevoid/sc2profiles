require 'bundler/setup'
require 'rake'

path = File.expand_path "../", __FILE__

namespace :db do
  
  desc "auto migrate db"
  task :automigrate do
    require "#{path}/config/env"
    DataMapper.auto_migrate!
  end

end

namespace :scraper do
  desc "scrape"
  task :scrape do
    require "#{path}/config/env"
    Scraper.scrape
  end
end