express = require 'express'
app = express.createServer()

app.configure ->
  app.use require('connect-assets')()
  app.use express.bodyParser()

app.get '/wall', (req, res) ->
  res.render 'wall.jade', {layout: false}

app.get '/twitter', (req, res) ->
  res.render 'twitter.jade', {layout: false}

app.post '/proxy', (req, res) ->
  require('request') req.body.url, (error, apiResponse, apiBody) ->
    if error?
      res.send error if error?
    else
      try
        res.send
          "headers": apiResponse.headers
          "body": JSON.parse apiBody
      catch ex
        res.send
          "headers": apiResponse.headers
          "body": apiBody
          "error": ex.message

app.get '*', (req, res) ->
  res.redirect 'wall'

port = process.env.PORT
app.listen port, () -> console.log "Listening on port #{port}"

io = require('socket.io').listen(app)

broadcastLatest = ->
  io.sockets.emit 'test', 'o'

setInterval broadcastLatest, 5000
