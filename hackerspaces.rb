require 'sinatra'
require 'coffee-script'
require 'net/http'
require 'uri'
require 'dalli'
require './fetch-status'

get '/wall' do
  haml :wall
end

get '/styles.css' do
  scss :styles
end

get '/main.js' do
  coffee :main
end

post '/proxy' do
  headers 'Content-Type' => 'application/json'
  url = request.body.read
  settings.cache.fetch(url, 50) do
    fetchStatus URI.parse url
  end
end

get '*' do
  redirect '/wall'
end

set :cache, Dalli::Client.new

set :static_cache_control, [:public, :max_age => 86400]

before do
  expires 3600, :public, :must_revalidate if production?
end
