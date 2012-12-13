twitter = require 'ntwitter'
mongojs = require 'mongojs'

twit = new twitter
  consumer_key: process.env.TWITTER_CONSUMER_KEY
  consumer_secret: process.env.TWITTER_CONSUMER_SECRET
  access_token_key: process.env.TWITTER_ACCESS_TOKEN
  access_token_secret: process.env.TWITTER_ACCESS_TOKEN_SECRET

db = mongojs process.env.MONGO_URL, ['spaces', 'tweets']

getTwitterIds = (callback) ->
  query =
    twitter_id:
      $exists: true
      $ne: null

  db.spaces.find query, twitter_id: true, (err, ids) ->
    callback ids.map((result) -> result.twitter_id)

exports.listen = (callback) ->
  getTwitterIds (err, ids) ->
    twit.stream 'statuses/filter', {follow: ids}, (stream) ->
      stream.on 'error', (data) ->
        console.log data
      stream.on 'data', (data) ->
        return if data.disconnect?
        callback data
        database.connect 'tweets', (err, db, tweets) ->
          tweets.insert data if !err

exports.recent = (max, callback) ->
  db.tweets.find()
    .sort($natural: -1)
    .limit max, (err, tweets) ->
      for tweet in tweets
        callback null, tweet
