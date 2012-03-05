require 'sinatra'
require 'coffee-script'
require 'dalli'
require './proxy'

use Proxy

get '/wall' do
  haml :wall
end

get '/styles.css' do
  scss :styles
end

get '/main.js' do
  coffee :main
end

get '*' do
  redirect '/wall'
end

set :cache, Dalli::Client.new

set :static_cache_control, [:public, :max_age => 86400]

before do
  expires 3600, :public, :must_revalidate if production?
end
