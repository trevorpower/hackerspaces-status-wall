require 'json'

def fetchStatus uri, limit = 5
  return {:error => "To many HTTP redirects"}.to_json if limit == 0
  response = Net::HTTP.get_response(uri)
  case response
  when Net::HTTPSuccess then
    response.body
  when Net::HTTPRedirection then
    location = URI.parse(response['Location'])
    location = uri.merge(location) if location.relative?
    fetchStatus location, limit - 1
  else
    {:error => "#{response.value}"}.to_json
  end
rescue => e
  if uri.scheme == 'https'
    uri.scheme = 'http'
    fetchStatus uri, limit
  else
    {:error => e.message}.to_json
  end
end
