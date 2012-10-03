twitter = require 'ntwitter'
twit = new twitter
  consumer_key: process.env.TWITTER_CONSUMER_KEY
  consumer_secret: process.env.TWITTER_CONSUMER_SECRET
  access_token_key: process.env.TWITTER_ACCESS_TOKEN
  access_token_secret: process.env.TWITTER_ACCESS_TOKEN_SECRET

database = require('../database') require('../db_settings')

getTwitterIds = (callback) ->
  database.connect (err, db) ->
    if err
      callback err
    else
      console.log 'connected to db'
      db.command
        distinct: "tweeps"
        key: "user.id",
        (err, result) ->
          if err
            callback err
          else
            callback err, result.values

exports.listen = (callback) ->
  getTwitterIds (err, ids) ->
    twit.stream 'statuses/filter', {follow: ids}, (stream) ->
      stream.on 'error', (data) ->
        console.log data
      stream.on 'data', (data) ->
        callback data
        database.connect 'tweets', (err, db, tweets) ->
          tweets.insert data if !err

exports.recent = (max, callback) ->
  database.connect 'tweets', (err, db, tweets) ->
    tweets
      .find(disconnect: {$exists: false})
      .sort($natural: -1)
      .limit(max)
      .each(callback)
