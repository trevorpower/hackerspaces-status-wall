request = require 'request'
async = require 'async'
twitterApi = "http://api.twitter.com/1/"

require('../database').connect 'hackerspaces-me', 'tweeps', (err, db, tweeps) ->
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

    require('../lib/twitterScreenNames')  db, (err, names) ->
      console.log "got #{names.length} screen names"
      async.forEach names, saveTwitterInfo, (err) ->
        process.exit()
