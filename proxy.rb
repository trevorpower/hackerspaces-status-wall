require 'sinatra/base'
require 'net/http'
require 'dalli'

class Proxy < Sinatra::Base
  
  set :cache, Dalli::Client.new

  post '/proxy' do
    headers 'Content-Type' => 'application/json'
    url = request.body.read
    settings.cache.fetch(url, 300) do
      puts "proxy request not cached: #{url}"
      fetchStatus URI.parse url
    end
  end

  def fetchStatus uri, limit = 5
    return {:error => "To many HTTP redirects"}.to_json if limit == 0
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.read_timeout = 25
    http.start do |http|
      handleResponse uri, http.request_get(uri.request_uri), limit
    end
  rescue => e
    {:error => e.message}.to_json
  end

  def handleResponse uri, response, limit
    case response
    when Net::HTTPSuccess
      response.body
    when Net::HTTPRedirection
      followRedirection uri, response, limit
    else
      {:error => response.value}.to_json
    end
  end

  def followRedirection uri, response, limit
    location = URI.parse(response['Location'])
    location = uri.merge(location) if location.relative?
    fetchStatus location, limit - 1
  end

end