express = require 'express'
request = require 'request'
directory_summary = null

app = express.createServer()

app.configure ->
  app.use require('connect-assets')
    jsCompilers: require('./jade-assets')
  app.use express.bodyParser()
  app.set 'view options', {layout: false}

app.get '/wall', (req, res) ->
  res.render 'wall.jade', directory_summary

app.post '/proxy', (req, res) ->
  request req.body.url, (error, apiResponse, apiBody) ->
    if error?
      res.send error if error?
    else
      try
        res.send
          "headers": apiResponse.headers
          "body": JSON.parse apiBody
      catch ex
        res.send
          "headers": apiResponse.headers
          "body": apiBody
          "error": ex.message

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
        console.log directory_summary
        port = process.env.PORT
        app.listen port, () -> console.log "Listening on port #{port}"

require('./server/events').start(app)
