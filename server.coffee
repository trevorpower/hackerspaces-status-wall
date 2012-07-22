express = require 'express'
path = require 'path'

app = express.createServer()

app.configure ->
  app.use express.static('generated_static')

port = process.env.PORT
app.listen port, () -> console.log "Listening on port #{port}"
