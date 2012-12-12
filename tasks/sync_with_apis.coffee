request = require 'request'
mongojs = require 'mongojs'
async = require 'async'

db = mongojs process.env.MONGO_URL, ['spaces']

screenName = (status) ->
  name = status.contact?.twitter
  if name and name[0] == '@'
    name.substring 1
  else
    name

update_space = (space, callback) ->
  request
    uri: space.api
    json: true,
    (err, res, body) ->
      if err
        console.log "error for #{space.name}: #{err}"
        callback()
      else
        info =
          twitter_handle: screenName(body)
          logo: body.logo
        db.spaces.update space, info, (err) ->
          console.log "#{space.name} synced"
          callback()

db.spaces.find (err, spaces) ->
  async.forEach spaces, update_space, (err) ->
    console.log err if err
    process.exit()
