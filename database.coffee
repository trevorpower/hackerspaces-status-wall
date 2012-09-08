Mongo = require 'mongodb'
async = require 'async'

add_collections = (err, db, collections..., callback) ->
  get_collection = (name, callback) -> db.collection name, callback
  async.map collections, get_collection, (err, collections) ->
    callback(err, db, collections...)

connect = (collections..., callback) ->
  server = new Mongo.Server(
    process.env.MONGO_HOST,
    parseInt process.env.MONGO_PORT,
    {}
  )
  new Mongo.Db('hackerspaces-me', server)
    .open (err, db) ->
      if err
        callback err
      else
        if process.env.MONGO_USER
          db.authenticate(
            process.env.MONGO_USER,
            process.env.MONGO_PASSWORD,
            (err, authenticated) ->
              if authenticated
                add_collections err, db, collections..., callback
              else
                callback 'failed to authenticate'
          )
        else
          add_collections err, db, collections..., callback

exports.connect = connect

exports.create = (callback) ->
  connect (err, db) ->
    if !err
      collections = require './database/collections'
      create = (o, c) ->
        console.log "creating #{o.create}"
        db.executeDbCommand(o, c)
      async.forEach collections, create, callback
    else
      callback err