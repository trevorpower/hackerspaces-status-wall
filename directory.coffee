Mongo = require 'mongodb'

with_database = (callback) ->
  server = new Mongo.Server(process.env.MONGO_HOST, parseInt process.env.MONGO_PORT, {})
  db = new Mongo.Db('hackerspaces-me', server)
  db.open (err, db) ->
    db.authenticate process.env.MONGO_USER, process.env.MONGO_PASSWORD, (err, authenticated) ->
      if authenticated
        callback(err, db)

with_directories = (callback) ->
  with_database (err, db) ->
    if !err
      db.collection 'directories', (err, collection) ->
        callback collection if !err

exports.create = (callback) ->
  with_database (err, db) ->
    if !err
      db.executeDbCommand(
        {
          create: 'directories'
          capped: true
          size: 10000000
        },
        (err) ->
          if err
            callback err
          else
            callback()
      )

exports.store = (spaces, callback) ->
  with_directories (directories) ->
    directories.insert {date: new Date(), spaces: spaces}, (err) ->
      callback(err)

exports.latest = (callback) ->
  with_directories (directories) ->
    directories
      .find()
      .sort({$natural: -1})
      .limit(1)
      .toArray (err, items) ->
        callback items[0] if !err
