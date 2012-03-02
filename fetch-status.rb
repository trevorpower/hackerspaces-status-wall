require 'json'

def fetchStatus uri, limit = 5
  return {:error => "To many HTTP redirects"}.to_json if limit == 0
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = uri.scheme == 'https'
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  http.start do |http|
    handleResponse uri, http.request_get(uri.request_uri), limit
  end
rescue => e
  #return tryHttp uri, limit if uri.scheme == 'https'
  {:error => e.message}.to_json
end

def handleResponse uri, response, limit
  case response
  when Net::HTTPSuccess then response.body
  when Net::HTTPRedirection then followRedirection uri, response, limit
  else {:error => response.value}.to_json
  end
end

def followRedirection uri, response, limit
  location = URI.parse(response['Location'])
  location = uri.merge(location) if location.relative?
  fetchStatus location, limit - 1
end

def tryHttp uri, limit
  uri.scheme = 'http'
  fetchStatus uri, limit
end
