database = require('../database/database') require('../database/settings/production')
createDirectory = require '../lib/directory'
request = require 'request'

console.log 'requesting directory'

complete = (status) ->
  console.log status
  process.exit()

id = (name) ->
  name.toLowerCase().replace /[^a-z0-9]+/g, '-'

request
  uri: "http://chasmcity.sonologic.nl/spacestatusdirectory.php"
  json: true,
  (err, res, body) ->
    if err
      complete err
    else
      console.log 'reply recieved'
      database.connect 'spaces', (err, db, spaces) ->
        if err
          complete err
        else
          for name, url of body
            query = id: id(name)
            update =
              $set:
                api: url
            spaces.update query, update, {upsert: true}, (err) ->
              if err
                console.log err
              else
                console.log "#{name} updated"
          complete 'done'
