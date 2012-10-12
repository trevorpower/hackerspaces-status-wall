twitter = require '../lib/twitter'
poller = require('../lib/status_poller')(process.env.POLL_CONCURRENCY)

exports.start = (db, io, directory) ->

  io.sockets.on 'connection', (socket) ->
    socket.on 'previous tweets', (max) ->
      twitter.recent max, (err, tweet) ->
        socket.emit 'previous tweet', tweet if !err

  twitter.listen (tweet) ->
    io.sockets.emit 'new tweet', tweet

  poller.listen directory, (space) ->
    io.sockets.emit 'new status', space.status
