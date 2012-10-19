twitter = require '../lib/twitter'
request = require '../lib/status_request'

poller = require('../lib/status_poller')(process.env.POLL_CONCURRENCY, request)

exports.start = (db, io, directory) ->

  io.sockets.on 'connection', (socket) ->
    socket.on 'previous tweets', (max) ->
      twitter.recent max, (err, tweet) ->
        socket.emit 'previous tweet', tweet if !err
    socket.on 'replay statuses', () ->
      console.log 'replay requested'
      poller.current (status) ->
        console.log "replay status for #{status.space}"
        socket.emit 'new status', status

  twitter.listen (tweet) ->
    io.sockets.emit 'new tweet', tweet

  poller.listen directory, (status) ->
    console.log "new status for #{status.space}"
    io.sockets.emit 'new status', status
