express = require 'express'

app = express.createServer()

app.configure ->
  app.use require('connect-assets')()
  app.use express.bodyParser()

app.get '/wall', (req, res) ->
  res.render 'wall.jade', {layout: false}

app.post '/proxy', (req, res) ->
  require('request')
  res.send 'proxy'
  

app.get '*', (req, res) ->
 res.redirect 'wall'

port = process.env.PORT
app.listen port, () -> console.log "Listening on port #{port}"
