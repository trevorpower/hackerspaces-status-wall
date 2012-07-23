express = require 'express'
path = require 'path'

app = express.createServer()

app.configure ->
  app.use require('connect-assets')()

app.get '/wall', (req, res) ->
  res.render 'wall.jade', {layout: false}

app.get '*', (req, res) ->
 res.redirect 'wall'

port = process.env.PORT
app.listen port, () -> console.log "Listening on port #{port}"
