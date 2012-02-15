require 'sinatra'
require 'coffee-script'

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
