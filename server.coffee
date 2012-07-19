express = require 'express'

app = express.createServer()

app.get '/', (request, response) ->
  response.send 'hello'

port = process.env.PORT
app.listen port, () -> console.log "Listening on port #{port}"
