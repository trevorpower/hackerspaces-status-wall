twitter = require 'ntwitter'
twit = new twitter
  consumer_key: process.env.TWITTER_CONSUMER_KEY
  consumer_secret: process.env.TWITTER_CONSUMER_SECRET
  access_token_key: process.env.TWITTER_ACCESS_TOKEN
  access_token_secret: process.env.TWITTER_ACCESS_TOKEN_SECRET

dbSettings = {name: 'hackerspaces-me'}

getTwitterIds = (callback) ->
  require('../database')(dbSettings).connect (err, db) ->
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
        require('../database')(dbsettings).connect 'tweets', (err, db, tweets) ->
          tweets.insert data if !err

exports.recent = (max, callback) ->
  require('../database')(dbSettings).connect 'tweets', (err, db, tweets) ->
    tweets
      .find()
      .sort($natural: -1)
      .limit(max)
      .each callback
