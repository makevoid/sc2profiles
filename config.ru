require 'bundler/setup'

require 'sinatra'

if ENV["RACK_ENV"] == "production"
  require "sc2profiles"
else
  path = File.expand_path "../", __FILE__
  require "#{path}/sc2profiles"
end


run Sinatra::Application unless ENV['OS'] == "Windows_NT"