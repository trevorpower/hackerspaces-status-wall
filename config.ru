require './hackerspaces'
require 'rack/cache'

use Rack::Cache

run Sinatra::Application
