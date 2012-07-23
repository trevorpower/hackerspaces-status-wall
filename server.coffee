express = require 'express'
path = require 'path'

app = express.createServer()

app.configure ->
  app.use express.static('generated_static')

app.get '*', (req, res) ->
  res.redirect 'wall'

port = process.env.PORT
app.listen port, () -> console.log "Listening on port #{port}"
