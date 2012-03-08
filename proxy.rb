require 'sinatra/base'
require 'net/http'
require 'dalli'
require 'faraday_middleware'
require 'json'

class Proxy < Sinatra::Base
  
  set :cache, Dalli::Client.new

  post '/proxy' do
    headers 'Content-Type' => 'application/json'
    url = request.body.read
    settings.cache.fetch url, 180 do
      puts "#{url}: not cached"
      fetch(url).to_json
    end
  end

  def fetch url
    response = connection(url).get
    { :headers => response.headers, :body => response.body }
  rescue => e
    { :error => e.message }
  end

  def connection url
    options = {
      :timeout => 20,
      :open_timeout => 10,
      :ssl => {:ca_file => '/usr/lib/ssl/certs/ca-certificates.crt'},
      :user_agent => 'hackerspaces.me server side proxy'
    }
    Faraday.new url, options do |conn|
      conn.use FaradayMiddleware::ParseJson
      conn.use FaradayMiddleware::FollowRedirects
      conn.adapter :net_http
    end
  end
end
