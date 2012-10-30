database = require('../database/database') require('../database/settings/production')

async = require 'async'
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

  createLogo = (space, callback) ->
    logo = null
    if space.url
      #console.log "creating logo from #{space.url}"
      logo = gm space.url
    else
      console.log "!!!   creating empty logo for #{space.name}"
      logo = gm 200, 400, 0x003300aa
    logo.write "logos/#{space.name}.png", (err) ->
      console.log err if err
      callback()

  latest directories, (err, directory) ->
    if err
      callback err
    else
      console.log "directory found for #{directory.date}"
      names = for name, value of directory.spaces
        name
      query db, names, (err, urls) ->
        spaces = for name, url of urls
          name: name, url: url
        async.forEach spaces, createLogo, callback

database.connect 'directories', (err, db, directories) ->
  if err
    console.log err
    process.exit()
  else
    update_logos db, directories, (err) ->
      console.log err
      process.exit()
