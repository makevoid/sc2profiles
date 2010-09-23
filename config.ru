require 'bundler/setup'

require 'sinatra'


path = File.expand_path "../", __FILE__
require "#{path}/sc2profiles"



run Sinatra::Application unless ENV['OS'] == "Windows_NT"