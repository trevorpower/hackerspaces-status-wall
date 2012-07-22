express = require 'express'
path = require 'path'

app = express.createServer()

generated_static = 'generated_static'

app.get '/wall', (request, response) ->
  response.sendfile path.join(generated_static, 'wall.html')

port = process.env.PORT
app.listen port, () -> console.log "Listening on port #{port}"
