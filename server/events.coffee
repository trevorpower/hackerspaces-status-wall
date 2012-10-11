twitter = require '../lib/twitter'
request = require 'request'

poll = (space, callback) ->
  request space.url, (error, apiResponse, apiBody) ->
    if error?
      console.log "ERROR from #{space.name}: #{error}"
    else
      console.log "response from #{space.name}"
    callback()

queue = require('async').queue(poll, 2)
  
queue_spaces = (directory) ->
  console.log 'queuing directory'
  for name, url of directory
    queue.push {name: name, url: url}

exports.start = (io, directory) ->

  io.sockets.on 'connection', (socket) ->
    socket.on 'previous tweets', (max) ->
      twitter.recent max, (err, tweet) ->
        socket.emit 'previous tweet', tweet if !err

  twitter.listen (tweet) ->
    io.sockets.emit 'new tweet', tweet

  queue_spaces directory

  queue.empty = () ->
    queue_spaces directory

  
