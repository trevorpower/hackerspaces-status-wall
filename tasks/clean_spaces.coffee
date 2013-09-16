mongojs = require 'mongojs'
async = require 'async'

module.exports = (callback) ->
  db = mongojs process.env.MONGO_URL, ['spaces', 'events']
  log = require('../lib/logger') db.events, "Clean"

  old = new Date()
  old.setDate old.getDate() - 4

  log.info "Started", "Removing spaces not synced since #{old}."

  db.spaces.remove
    synced:
      $lt: old,
    (err, result) ->
      if err
        log.error err
      else
        log.info "Complete", "#{result} spaces removed."
      process.exit()
