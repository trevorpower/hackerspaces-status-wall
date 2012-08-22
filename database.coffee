Mongo = require 'mongodb'
async = require 'async'

connect = (callback) ->
  server = new Mongo.Server(process.env.MONGO_HOST, parseInt process.env.MONGO_PORT, {})
  db = new Mongo.Db('hackerspaces-me', server)
  db.open (err, db) ->
    if err
      callback err, db
    else
      if process.env.MONGO_USER
        db.authenticate process.env.MONGO_USER, process.env.MONGO_PASSWORD, (err, authenticated) ->
          if authenticated
            callback(err, db)
      else
        callback(err, db)

exports.connect = connect

exports.create = (callback) ->
  connect (err, db) ->
    if !err
      collections = [
        { create: 'directories', capped: true, size: 10000000 },
        { create: 'spaces', capped: true, size: 80000000 }
      ]
      create = (o, c) -> db.executeDbCommand(o, c)
      async.forEach collections, create, callback
    else
      callback err
