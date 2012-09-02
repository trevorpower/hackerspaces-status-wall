request = require 'request'
async = require 'async'
twitterApi = "http://api.twitter.com/1/"

getScreenNames = (db, callback) ->
  db.command
    distinct: "spaces"
    key: "status.contact.twitter",
    (err, result) ->
      if err
        callback err
      else
        callback err, result.values.map((s) -> s.substring(1))

require('../database').connect 'tweeps', (err, db, tweeps) ->
  saveTwitterInfo = (name, callback) ->
    console.log "requesting info for @#{name}"
    request "#{twitterApi}users/show.json?screen_name=#{name}", (err, res, body) ->
      if res.statusCode == 200
        tweeps.insert(
          {date: new Date(), user: JSON.parse(body)}
          (err) ->
            if err
              console.log err
            else
              console.log "saved tweep #{name}" if !err
            callback()
        )
      else
        console.log "#{res.statusCode}: #{err} - #{name}"
        callback()

  if err
    console.log err
  else
    console.log "connected to #{db}"

    getScreenNames db, (err, names) ->
      console.log "got #{names.length} screen names"
      async.forEach names, saveTwitterInfo, (err) ->
        process.exit()
