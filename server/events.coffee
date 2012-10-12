twitter = require '../lib/twitter'
request = require 'request'
createStatusDocument = require '../lib/space_info'
database = require('../database/database') require('../database/settings/production')

spaces = null

hasChanged = (a, b) ->
  a.open != b.open or a.status != b.status

poll = (space, callback) ->
  request space.url, (err, res, body) ->
    if err
      console.log "error for #{space.name}: #{err}"
      callback()
    else
      statusDocument = createStatusDocument body

      spaces.insert statusDocument, (err) ->
        if err
          console.log err
        else
          console.log "saved for #{space.name}"
        callback()

queue = require('async').queue(poll, 3)
  
queue_spaces = (directory) ->
  console.log 'queuing directory'
  for name, url of directory
    queue.push {name: name, url: url}

exports.start = (db, io, directory) ->

  database.connect 'spaces', (err, db, collection) ->
    spaces = collection

  io.sockets.on 'connection', (socket) ->
    socket.on 'previous tweets', (max) ->
      twitter.recent max, (err, tweet) ->
        socket.emit 'previous tweet', tweet if !err

  twitter.listen (tweet) ->
    io.sockets.emit 'new tweet', tweet

  queue_spaces directory

  queue.empty = () ->
    queue_spaces directory

  
