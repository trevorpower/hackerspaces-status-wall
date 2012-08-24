request = require 'request'
async = require 'async'

update_space_status = (space, callback) ->
  console.log "requesting #{space.url}"
  request space.url, (err, res, body) ->
    if err
      console.log "error for #{space.name}: #{err}"
    else
      console.log "reply for #{space.name}"
      status = JSON.parse body
      console.log "saved for #{space.name}"
    callback null

async.waterfall([

  (next) ->
    require('./database').connect(next)

  (db, next) ->
    console.log 'connected to database'
    db.collection('directories', next)

  (directories, next) ->
    directories
      .find()
      .sort({$natural: -1})
      .limit(1)
      .toArray next

  (directories, next) ->
    latest = directories[0]
    console.log "directory found for #{latest.date}"
    spaces = for name, url of latest.spaces
      {name: name, url: url}
    async.forEach spaces, update_space_status, next

  ],
  (err) ->
    console.log err if err
    process.exit()
)
