require 'sinatra/base'
require 'net/http'
require 'dalli'
require 'faraday_middleware'

class Proxy < Sinatra::Base
  
  set :cache, Dalli::Client.new

  post '/proxy' do
    headers 'Content-Type' => 'application/json'
    url = request.body.read
    settings.cache.fetch url, 180 do
      puts "#{url}: not cached"
      connection = Faraday.new url, :ssl => {:ca_file => '/usr/lib/ssl/certs/ca-certificates.crt'} do |conn|
        conn.use FaradayMiddleware::FollowRedirects
        conn.adapter :net_http
      end
      connection.get.body
    end
  end
end
