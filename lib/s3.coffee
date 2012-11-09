knox = require 'knox'

module.exports = (settings) ->

  client = knox.createClient settings

  putStream: (args...) -> client.putStream(args...)
  putBuffer: (args...) -> client.putBuffer(args...)

