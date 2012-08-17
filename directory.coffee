Mongo = require 'mongodb'

with_directories = (callback) ->
  server = new Mongo.Server('localhost', 27017, {})
  db = new Mongo.Db('hackerspaces-me', server)
  db.open (err, db) ->
    if !err
      db.collection 'directories', (err, collection) ->
        callback collection if !err

exports.store = (spaces) ->
  with_directories (directories) ->
    directories.insert
      date: new Date()
      spaces: spaces

exports.latest = (callback) ->
  with_directories (directories) ->
    directories.findOne {}, (err, item) ->
      if !err
        callback item
