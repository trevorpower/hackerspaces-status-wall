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

twitter = require 'ntwitter'

twit = new twitter
  consumer_key: process.env.TWITTER_CONSUMER_KEY
  consumer_secret: process.env.TWITTER_CONSUMER_SECRET
  access_token_key: process.env.TWITTER_ACCESS_TOKEN
  access_token_secret: process.env.TWITTER_ACCESS_TOKEN_SECRET

filter = { 'follow' : '16102766' }

twit.stream 'statuses/filter', filter, (stream) ->
  stream.on 'data', (data) ->
    io.sockets.emit 'message', data
