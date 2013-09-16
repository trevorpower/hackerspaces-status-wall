request = require 'request'
async = require 'async'

directory = "http://spaceapi.net/directory.json"

module.exports = (callback) ->

  db = require('mongojs') process.env.MONGO_URL, ['spaces', 'events']

  log = require('../lib/logger') db.events, "Directory Sync"

  complete = (err) ->
    console.log err if err
    callback()

  id = (name) ->
    name.toLowerCase().replace /[^a-z0-9]+/g, ''

  slug = (name) ->
    name.toLowerCase()
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-/, '')
      .replace(/-$/, '')

  syncSpace = (space, callback) ->
    [name, url] = space
    query = id: id(name)
    update =
      $set:
        name: name
        slug: slug name
        api: url
        synced: new Date()
    db.spaces.update query, update, {upsert: true}, (err) ->
      console.log err if err
      callback()

  log.info "Started", "Requesting directory from '#{directory}'"

  request
    uri: directory
    json: true,
    (err, res, body) ->
      if err
        log.error JSON.stringify(err)
        callback()
      else
        spaces = for name, url of body
          [name, url]
        async.forEachSeries spaces, syncSpace, (err) ->
          unless err
            log.info "Complete", "#{spaces.length} spaces in directory"
          complete err
