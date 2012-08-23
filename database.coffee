Mongo = require 'mongodb'
async = require 'async'

schema = [
  { create: 'directories', capped: true, size: 10000000 },
  { create: 'spaces', capped: true, size: 80000000 }
]

connect = (callback) ->
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
                callback(err, db)
              else
                callback 'failed to authenticate'
          )
        else
          callback(err, db)

exports.connect = connect

exports.create = (callback) ->
  connect (err, db) ->
    if !err
      create = (o, c) -> db.executeDbCommand(o, c)
      async.forEach schema, create, callback
    else
      callback err
