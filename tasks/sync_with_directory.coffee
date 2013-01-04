request = require 'request'
async = require 'async'

module.exports = (callback) ->

  db = require('mongojs') process.env.MONGO_URL, ['spaces']

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

  console.log 'requesting directory'

  request
    uri: "http://chasmcity.sonologic.nl/spacestatusdirectory.php"
    json: true,
    (err, res, body) ->
      if err
        complete err
      else
        console.log 'reply recieved'
        spaces = for name, url of body
          [name, url]
        console.log "#{spaces.length} spaces in directory"
        async.forEachSeries spaces, syncSpace, (err) ->
          console.log "directory sync complete"
          complete err

