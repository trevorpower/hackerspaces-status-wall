express = require 'express'
directory_summary = null

app = express.createServer()

app.configure ->
  app.use require('connect-assets')
    jsCompilers: require('./jade-assets')
  app.use express.bodyParser()
  app.set 'view options', {layout: false}

app.get '/wall', (req, res) ->
  res.render 'wall.jade', directory_summary

app.post '/proxy', require('./server/proxy')

app.get '*', (req, res) ->
  res.redirect 'wall'

database = require('./database') require('./db_settings')
database.connect 'directories', (err, db, directories) ->
  directories
    .find()
    .sort($natural: -1)
    .limit(1)
    .each (err, directory) ->
      if err
        console.log err
      else if directory
        directory_summary = {total: Object.keys(directory.spaces).length}
        port = process.env.PORT
        app.listen port, () -> console.log "Listening on port #{port}"

require('./server/events').start(app)
