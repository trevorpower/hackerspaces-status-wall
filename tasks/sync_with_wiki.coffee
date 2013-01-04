request = require 'request'
mongojs = require 'mongojs'
async = require 'async'

module.exports = (callback) ->
  db = mongojs process.env.MONGO_URL, ['spaces']

  spaceId = (name) ->
    name.toLowerCase()
      .replace(/[^a-z0-9]+/g, '')

  spaceSlug = (name) ->
    name.toLowerCase()
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-/, '')
      .replace(/-$/, '')

  extractTwitterHandle = (url) ->
    return null unless url

    if url.indexOf('tter.com') != -1
      url.match(/[^\/@#]+(?=(\/$)|$)/)[0]
    else if url.indexOf('/') == -1
      url.match(/[^:@]+$/)[0]
    else
      console.log "unable to extract handle from #{url}"
      null

  extractLocation = (location) ->
    return null unless location
    [location.lat, location.lon]

  syncSpace = (space, callback) ->
    id = spaceId space.label
    update =
      $set:
        name: space.label
        slug: spaceSlug space.label
        synced: new Date()
    query = id: id

    twitter = extractTwitterHandle space.twitter
    if twitter
      update.$set['twitter_handle'] = twitter

    location = extractLocation space.location
    if location
      update.$set['location'] = location

    db.spaces.update query, update, {upsert: true}, (err) ->
      #console.log "'#{space.label}' synced"
      console.log err if err
      callback()

  syncSpaces = (offset, limit, callback) ->
    query =
      uri: 'http://hackerspaces.org/wiki/Special:Ask'
      json: true
      qs:
        q: '[[Category:Hackerspace]][[Hackerspace status::!planned]]'
        po: '?Twitter\n?Location'
        'p[format]': 'json'
        limit: limit
        offset: offset
    console.log "requesting spaces from wiki #{offset} -> #{offset + limit}"
    request query, (err, response, body) ->
      if err
        console.log err
      else
        async.forEachSeries body.items, syncSpace, () ->
          if body.items.length == limit
            syncSpaces offset + limit, limit, callback
          else
            callback()

  syncSpaces 0, 100, callback
