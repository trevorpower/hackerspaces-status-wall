twitter = require '../lib/twitter'
sockets = require 'socket.io'

exports.start = (app, directory) ->
  io = sockets.listen(app)

  io.configure () ->
    io.set "transports", ["xhr-polling"]
    io.set "polling duration", 10
    io.set "log level", 2

  io.sockets.on 'connection', (socket) ->
    socket.on 'previous tweets', (max) ->
      twitter.recent max, (err, tweet) ->
        socket.emit 'previous tweet', tweet if !err

  twitter.listen (tweet) ->
    io.sockets.emit 'new tweet', tweet
