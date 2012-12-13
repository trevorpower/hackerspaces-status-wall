request = require 'request'
mongojs = require 'mongojs'

db = mongojs process.env.MONGO_URL, ['spaces']

query =
  uri: 'http://hackerspaces.org/wiki/Special:Ask'
  json: true
  qs:
    q: '[[Category:Hackerspace]][[Twitter::+]]'
    po: '?Twitter'
    'p[format]': 'json'
    limit: 30

spaceId = (name) ->
  name.toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-/, '')
    .replace(/-$/, '')

extractTwitterHandle = (url) ->
  if url.indexOf('twitter.com') != -1
    console.log url
    url.match(/[^\/]+(?=(\/$)|$)/)[0]
  else
    null

syncSpace = (space) ->
  id = spaceId space.label
  twitter = extractTwitterHandle space.twitter
  console.log twitter
  update = $set: {}
  query = id: id
  update.$set['twitter_handle'] = twitter if twitter

  db.spaces.update query, update, {upsert: true}, (err) ->
    if err
      console.log err
    else
      console.log "#{id} updated"

request query, (err, response, body) ->
  if err
    console.log err
  else
    for space in body.items
      syncSpace space
