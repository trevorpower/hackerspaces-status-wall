request = require 'request'

db = require('mongojs') process.env.MONGO_URL, ['spaces']

console.log 'requesting directory'

complete = (status) ->
  console.log status
  process.exit()

id = (name) ->
  name.toLowerCase().replace /[^a-z0-9]+/g, ''

slug = (name) ->
  name.toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-/, '')
    .replace(/-$/, '')

syncSpace = (name, url) ->
  query = id: id(name)
  update =
    $set:
      name: name
      slug: slug name
      api: url
      synced: new Date()
  db.spaces.update query, update, {upsert: true}, (err) ->
    if err
      console.log err
    else
      console.log "#{name} updated"

request
  uri: "http://chasmcity.sonologic.nl/spacestatusdirectory.php"
  json: true,
  (err, res, body) ->
    if err
      complete err
    else
      console.log 'reply recieved'
      for name, url of body
        syncSpace name, url
