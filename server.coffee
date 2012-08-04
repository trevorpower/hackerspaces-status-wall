express = require 'express'
request = require 'request'

app = express.createServer()

app.configure ->
  app.use require('connect-assets')
    jsCompilers:
      jade:
        match: /\.js$/
        compileSync: (sourcePath, source) ->
          require('jade')
            .compile(source, {client: true})
            .toString()
            .replace('anonymous', require('path').basename(sourcePath, '.jade'))
  app.use express.bodyParser()

app.get '/wall', (req, res) ->
  res.render 'wall.jade', {layout: false}

app.get '/twitter', (req, res) ->
  res.render 'twitter.jade', {layout: false}

app.post '/proxy', (req, res) ->
  request req.body.url, (error, apiResponse, apiBody) ->
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

tweets = require('./tweets')

tweets (tweet) ->
  io.sockets.emit 'message', tweet
