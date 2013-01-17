express = require 'express'

directory = null

app = express.createServer()

app.configure ->
  app.use require('connect-assets')
    jsCompilers: require('./jade-assets')
  app.use express.bodyParser()
  app.set 'view options', {layout: false}

app.get '/', (req, res) ->
  res.render 'wall.jade', directory

app.get '*', (req, res) ->
  res.redirect '/'

db = require('mongojs') process.env.MONGO_URL, ['spaces']

withApi =
  api:
    $exists: true
    $ne: null

withLocation =
  location:
    $exists: true
    $ne: null
locationFields =
  _id: 0
  id: 1
  location: 1
  name: 1

db.spaces.find(withApi).toArray (err, apis) ->
  if err
    console.log err
  else
    db.spaces.find(withLocation, locationFields).toArray (err, locations) ->
      if err
        console.log err
      else
        directory =
          total: apis.length
          locations: locations
        port = process.env.PORT
        app.listen port, () -> console.log "Listening on port #{port}"
        io = require('socket.io').listen(app)
        io.configure () ->
          io.set "transports", ["xhr-polling"]
          io.set "polling duration", 10
          io.set "log level", 1
        require('./events').start(io, apis)
