twitter = require '../lib/twitter'
poller = require '../lib/status_poller'

exports.start = (db, io, directory) ->

  io.sockets.on 'connection', (socket) ->
    socket.on 'previous tweets', (max) ->
      twitter.recent max, (err, tweet) ->
        socket.emit 'previous tweet', tweet if !err

  twitter.listen (tweet) ->
    io.sockets.emit 'new tweet', tweet

  poller.listen directory, (space) ->
    console.log "event from #{space.status.space}"
