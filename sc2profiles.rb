require 'sinatra'

path = File.expand_path "../", __FILE__

require "#{path}/config/env"

RANKS = ["diamond", "platinum", "gold", "silver", "bronze", "copper"]

set :public, "#{path}/public"
set :session, true

def rank(i)
  return nil if i.nil?
  RANKS[i-1]
end

get '/' do
  haml :index
end

  get '/scrape' do
    Scraper.scrape
    "scraped successfully!"
  end

unless ENV["RACK_ENV"] == "production"

  get '/migrate' do
    DataMapper.auto_migrate!
    Stats.create(updated_at: nil)
    "migrated successfully!"
  end
  
end