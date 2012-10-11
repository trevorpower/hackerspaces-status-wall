express = require 'express'
database = require('../database/database') require('../database/settings/production')

directory_summary = null

app = express.createServer()

app.configure ->
  app.use require('connect-assets')
    jsCompilers: require('./jade-assets')
  app.use express.bodyParser()
  app.set 'view options', {layout: false}

app.get '/wall', (req, res) ->
  res.render 'wall.jade', directory_summary

app.post '/proxy', require('./proxy')

app.get '*', (req, res) ->
  res.redirect 'wall'

database.connect 'directories', (err, db, directories) ->
  directories
    .find()
    .sort($natural: -1)
    .limit(1)
    .each (err, directory) ->
      if err
        console.log err
      else if directory
        directory_summary =
          directory: directory.spaces
          total: Object.keys(directory.spaces).length
        port = process.env.PORT
        app.listen port, () -> console.log "Listening on port #{port}"
        io = require('socket.io').listen(app)
        io.configure () ->
          io.set "transports", ["xhr-polling"]
          io.set "polling duration", 10
          io.set "log level", 2
        require('./events').start(io, directory.spaces)

