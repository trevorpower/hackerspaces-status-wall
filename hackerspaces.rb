require 'sinatra'
require 'coffee-script'
require 'net/http'
require 'uri'

get '/wall' do
  haml :wall
end

get '/styles.css' do
  scss :styles
end

get '/main.js' do
  coffee :main
end

post '/fetch' do
  url = request.body.read
  result = Net::HTTP.get_response(URI.parse(url))
  headers 'Content-Type' => 'application/json'
  body result.body
end

get '*' do
  redirect '/wall'
end
