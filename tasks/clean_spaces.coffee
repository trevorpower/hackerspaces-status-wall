mongojs = require 'mongojs'
async = require 'async'

module.exports = (callback) ->
  db = mongojs process.env.MONGO_URL, ['spaces']

  old = new Date()
  old.setDate old.getDate() - 4

  console.log "removing spaces not synced since #{old}"

  db.spaces.remove
    synced:
      $lt: old,
    process.exit
