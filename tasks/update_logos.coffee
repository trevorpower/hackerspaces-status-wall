database = require('../database/database') require('../database/settings/production')

query = require '../lib/logo_urls'
gm = require 'gm'

latest = (collection, callback) ->
  collection
    .find()
    .sort({$natural: -1})
    .limit(1)
    .toArray (err, list) ->
      if err
        callback err
      else
        callback err, list[0]

update_logos = (db, directories, callback) ->

  latest directories, (err, directory) ->
    if err
      callback err
    else
      console.log "directory found for #{directory.date}"
      names = for name, value of directory.spaces
        name
      query db, names, (err, urls) ->
        for name, url of urls
          console.log name
          logo.write "#{name}.png", callback

database.connect 'directories', (err, db, directories) ->
  if err
    console.log err
    process.exit()
  else
    update_logos db, directories, (err) ->
      process.exit()
