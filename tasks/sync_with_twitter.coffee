request = require 'request'
mongojs = require 'mongojs'
async = require 'async'

twitterApi = "http://api.twitter.com/1/users/show.json"

db = mongojs process.env.MONGO_URL, ['spaces']
 
saveTwitterInfo = (space, callback) ->
  request
    uri: "#{twitterApi}?screen_name=#{space.twitter_handle}"
    json: true,
    (err, res, body) ->
      if res.statusCode == 200
        info =
          $set:
            twitter_id: body.id
        db.spaces.update {id: space.id}, info, (err) ->
          if err
            console.log err
          else
            console.log "@#{space.twitter_handle} -> #{body.id}"
          callback()
      else
        console.log "@#{space.twitter_handle}"
        console.log "#{res.statusCode}: #{err} - #{space.name}"
        console.log body
        callback()

query =
  twitter_handle:
    $exists: true
    $ne: null
  $or: [
    { twitter_id: null },
    { twitter_id: {$exists: false} }
  ]


db.spaces.find(query).limit 20, (err, spaces) ->
  async.forEach spaces, saveTwitterInfo, (err) ->
    process.exit()
