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
    limit: 900

spaceId = (name) ->
  name.toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-/, '')
    .replace(/-$/, '')

extractTwitterHandle = (url) ->
  if url.indexOf('tter.com') != -1
    url.match(/[^\/@]+(?=(\/$)|$)/)[0]
  else if url.indexOf('/') == -1
    url.match(/[^:@]+$/)[0]
  else
    console.log "unable to extract handle from #{url}"
    null

syncSpace = (space) ->
  id = spaceId space.label
  twitter = extractTwitterHandle space.twitter
  update = $set: {}
  query = id: id
  if twitter
    update.$set['twitter_handle'] = twitter

  db.spaces.update query, update, {upsert: true}, (err) ->
    if err
      console.log err

request query, (err, response, body) ->
  if err
    console.log err
  else
    for space in body.items
      syncSpace space
