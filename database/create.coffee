async = require 'async'
collections = require './collections'

module.exports = (db, callback) ->
  createCommand = (command, done) ->
    console.log "creating #{command.create}"
    db.executeDbCommand command, done
  async.forEach collections, createCommand, callback
