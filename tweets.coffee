twitter = require 'ntwitter'
twit = new twitter
  consumer_key: process.env.TWITTER_CONSUMER_KEY
  consumer_secret: process.env.TWITTER_CONSUMER_SECRET
  access_token_key: process.env.TWITTER_ACCESS_TOKEN
  access_token_secret: process.env.TWITTER_ACCESS_TOKEN_SECRET


module.exports = (callback) ->
  d = 0
  require('fs').readFile 'ids.txt', 'ascii', (err, ids) ->
    #filter = {'follow' : ids.split('\n').filter((x) -> x != '')}
    twit.stream 'statuses/sample', {}, (stream) ->
      stream.on 'data', (data) ->
        d = d + 1
        if d == 30
          callback data
          d = 0
