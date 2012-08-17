Mongo = require 'mongodb'

with_database = (callback) ->
  server = new Mongo.Server('localhost', 27017, {})
  db = new Mongo.Db('hackerspaces-me', server)
  db.open callback

with_directories = (callback) ->
  with_database (err, db) ->
    if !err
      db.collection 'directories', (err, collection) ->
        callback collection if !err

exports.create = (callback) ->
  with_database (err, db) ->
    if !err
      db.executeDbCommand
        create: 'directories'
        capped: true
        size: 10000000
    callback(err)

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
