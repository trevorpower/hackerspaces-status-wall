async = require 'async'
collections = require './collections'

module.exports = (db, data, callback) ->
  createCommand = (command, done) ->
    db.executeDbCommand command, (err) ->
      collectionData = data[command.create]
      if collectionData
        db.collection command.create, (err, collection) ->
          collection.insert collectionData, (err) ->
            done()
      else
        done()
  async.forEach collections, createCommand, callback
