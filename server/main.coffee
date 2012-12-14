express = require 'express'

directory_summary = null

app = express.createServer()

app.configure ->
  app.use require('connect-assets')
    jsCompilers: require('./jade-assets')
  app.use express.bodyParser()
  app.set 'view options', {layout: false}

app.get '/', (req, res) ->
  res.render 'wall.jade', directory_summary

app.post '/proxy', require('./proxy')

app.get '*', (req, res) ->
  res.redirect '/'

db = require('mongojs') process.env.MONGO_URL, ['spaces']

query =
  api:
    $exists: true
    $ne: null
db.spaces.find(query).toArray (err, apis) ->
  if err
    console.log err
  else
    directory_summary =
      total: apis.length
    console.log directory_summary
    port = process.env.PORT
    app.listen port, () -> console.log "Listening on port #{port}"
    io = require('socket.io').listen(app)
    io.configure () ->
      io.set "transports", ["xhr-polling"]
      io.set "polling duration", 10
      io.set "log level", 1
    require('./events').start(io, apis)
