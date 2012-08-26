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

require('./database').connect (err, db) ->
  console.log "connected to db"

  saveTwitterInfo = (name, callback) ->
    console.log "requesting info for @#{name}"
    request "#{twitterApi}users/show.json?screen_name=#{name}", (error, response, body) ->
      if response.statusCode == 200
        console.log JSON.parse(body).id
      callback()

  getScreenNames db, (err, names) ->
    console.log "got #{names.length} screen names"
    async.forEach names, saveTwitterInfo, (err) ->
      process.exit()
