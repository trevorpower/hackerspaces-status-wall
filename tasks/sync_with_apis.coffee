request = require 'request'
mongojs = require 'mongojs'
async = require 'async'

module.exports = (callback) ->
  db = mongojs process.env.MONGO_URL, ['spaces']

  screenName = (status) ->
    name = status.contact?.twitter
    if name and name[0] == '@'
      name.substring 1
    else
      name

  slug = (name) ->
    name.toLowerCase()
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-/, '')
      .replace(/-$/, '')

  extractLocation = (status) ->
    return null unless status.lon and status.lat
    [status.lat, status.lon]

  update_space = (space, callback) ->
    request
      uri: space.api
      json: true,
      (err, res, body) ->
        if err
          console.log "error for #{space.slug}: #{err}"
          callback()
        else
          info =
            $set:
              name: body.space
              web: body.url
              twitter_handle: screenName(body)
              slug: slug body.space
              logo: body.logo

          location = extractLocation body
          info.$set['location'] = location if location

          db.spaces.update space, info, (err) ->
            console.log "#{space.slug} synced"
            callback()

  query =
    api:
      $exists: true
      $ne: null

  console.log "syncing to status APIs"

  db.spaces.find query, (err, spaces) ->
    async.forEach spaces, update_space, (err) ->
      console.log err if err
      callback()
