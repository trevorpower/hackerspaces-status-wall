twitter = require 'ntwitter'

twit = new twitter
  consumer_key: process.env.TWITTER_CONSUMER_KEY
  consumer_secret: process.env.TWITTER_CONSUMER_SECRET
  access_token_key: process.env.TWITTER_ACCESS_TOKEN
  access_token_secret: process.env.TWITTER_ACCESS_TOKEN_SECRET

mongojs = require 'mongojs'
async = require 'async'

module.exports = (callback) ->
  db = mongojs process.env.MONGO_URL, ['spaces']
   
  saveTwitterInfo = (user, callback) ->
    info =
      $set:
        twitter_id: user.id
    query =
      twitter_handle:
        $regex: user.screen_name
        $options: 'i'
    db.spaces.update query, info, (err) ->
      if err
        console.log err
      else
        console.log "@#{user.screen_name} -> #{user.id}"
      callback()

  query =
    distinct: 'spaces'
    key: 'twitter_handle'
    query:
      twitter_handle:
        $exists: true
        $ne: null
      $or: [
        { twitter_id: null },
        { twitter_id: {$exists: false} }
      ]

  db.command query, (err, spaces) ->
    handles = spaces.values.slice(0, 90)
    console.log handles
    twit.showUser handles, (err, result) ->
      if err
        console.log err
      else
        async.forEach result, saveTwitterInfo, callback
