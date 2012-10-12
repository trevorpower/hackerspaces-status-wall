twitter = require '../lib/twitter'
request = require 'request'
createStatusDocument = require '../lib/space_info'
database = require('../database/database') require('../database/settings/production')

statuses = {}

hasChanged = (a, b) ->
  a.open != b.open or a.status != b.status

poll = (space, callback) ->
  request space.url, (err, res, body) ->
    if err
      console.log "error for #{space.name}: #{err}"
      callback()
    else
      latest = createStatusDocument body

      current = statuses[space.name]
      if current? and hasChanged(latest.status, current.status)
        console.log "status update for #{space.name}"

      statuses[space.name] = latest

queue = require('async').queue(poll, 3)
  
queue_spaces = (directory) ->
  console.log 'queuing directory'
  for name, url of directory
    queue.push {name: name, url: url}

exports.start = (db, io, directory) ->

  io.sockets.on 'connection', (socket) ->
    socket.on 'previous tweets', (max) ->
      twitter.recent max, (err, tweet) ->
        socket.emit 'previous tweet', tweet if !err

  twitter.listen (tweet) ->
    io.sockets.emit 'new tweet', tweet

  queue_spaces directory

  queue.empty = () ->
    queue_spaces directory

  
