fs = require 'fs'

module.exports =

  putStream: (args...) -> client.putStream(args...)

  putBuffer: (buffer, id, headers, callback) ->
    out = fs.createWriteStream "./.local_store#{id}"
    out.on "open", () ->
      out.write buffer
      process.nextTick callback
    out
