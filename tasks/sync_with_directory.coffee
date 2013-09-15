request = require 'request'
async = require 'async'

directory = "http://spaceapi.net/directory.json"

module.exports = (callback) ->

  db = require('mongojs') process.env.MONGO_URL, ['spaces', 'events']

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

  db.events.insert
    date: new Date()
    activity: "Directory Sync"
    event: "Started"
    details: directory
    priority: "info"

  request
    uri: directory
    json: true,
    (err, res, body) ->
      if err
        db.events.insert
          date: new Date()
          activity: "Directory Sync"
          event: "Error"
          details: JSON.stringify(err)
          priority: "error"
        complete err
      else
        console.log 'reply recieved'
        spaces = for name, url of body
          [name, url]
        async.forEachSeries spaces, syncSpace, (err) ->
          unless err
            db.events.insert
              date: new Date()
              activity: "Directory Sync"
              event: "Complete"
              details: "#{spaces.length} spaces in directory"
              priority: "info"
          complete err

