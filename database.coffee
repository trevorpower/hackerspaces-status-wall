Mongo = require 'mongodb'
async = require 'async'

add_collections = (err, db, collections..., callback) ->
  get_collection = (name, callback) -> db.collection name, callback
  async.map collections, get_collection, (err, collections) ->
    callback(err, db, collections...)


module.exports = (options) ->
  console.log options
  connect: (collections..., callback) ->
    server = new Mongo.Server(
      options.host,
      options.port,
      {}
    )
    new Mongo.Db(options.name, server)
      .open (err, db) ->
        if err
          callback err
        else
          if options.user
            db.authenticate(
              options.user,
              options.password,
              (err, authenticated) ->
                if authenticated
                  add_collections err, db, collections..., callback
                else
                  callback 'failed to authenticate'
            )
          else
            add_collections err, db, collections..., callback
