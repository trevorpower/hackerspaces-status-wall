fs = require 'fs'

module.exports =

  putStream: (source, id, headers, callback) ->
    out = fs.createWriteStream "./.local_store#{id}"
    source.on "data", (data) ->
      out.write data
    source.on "end", (data) ->
      out.end()
      process.nextTick callback
    out
    
  putBuffer: (buffer, id, headers, callback) ->
    out = fs.createWriteStream "./.local_store#{id}"
    out.on "open", () ->
      out.write buffer
      process.nextTick callback
    out
