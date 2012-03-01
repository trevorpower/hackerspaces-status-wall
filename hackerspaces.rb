require 'sinatra'
require 'coffee-script'
require 'net/http'
require 'uri'
require 'json'
require 'dalli'

set :cache, Dalli::Client.new

set :static_cache_control, [:public, :max_age => 86400]

helpers do
  def getSpaceInfo(uri, limit = 4)
    begin
      return {:error => "To many HTTP redirects"}.to_json if limit == 0
      response = Net::HTTP.get_response(uri)
      case response
      when Net::HTTPSuccess then
        response.body
      when Net::HTTPRedirection then
        location = URI.parse(response['Location'])
        location = uri.merge(location) if location.relative?
        getSpaceInfo location, limit - 1
      else
        {:error => "#{response.value}"}.to_json
      end
    rescue => e
      if uri.scheme == 'https'
        uri.scheme = 'http'
        getSpaceInfo uri, limit
      else
        {:error => e.message}.to_json
      end
    end
  end
end

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
    getSpaceInfo URI.parse(url) 
  end
end

get '*' do
  redirect '/wall'
end

before do
  expires 3600, :public, :must_revalidate if production?
end
