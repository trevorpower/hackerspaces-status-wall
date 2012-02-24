require 'sinatra'
require 'coffee-script'
require 'net/http'
require 'uri'
require 'json'

helpers do
  def getSpaceInfo(uri)
    begin
      response = Net::HTTP.get_response(uri)
      response.body
    rescue => e
      {:error => e.message}.to_json
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
  getSpaceInfo URI.parse(request.body.read)
end

get '*' do
  redirect '/wall'
end
