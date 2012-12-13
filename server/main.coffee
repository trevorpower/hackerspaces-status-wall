express = require 'express'
database = require('../database/database') require('../database/settings/production')

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

database.connect 'spaces', (err, db, spaces) ->
  spaces.find().toArray (err, apis) ->
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
        io.set "log level", 2
      require('./events').start(db, io, apis)

