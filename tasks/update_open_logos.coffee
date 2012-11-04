database = require('../database/database') require('../database/settings/production')

async = require 'async'
query = require '../lib/logo_urls'
store = require('knox').createClient require('../s3_settings')
request = require 'request'
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

upload = (url, id, report, callback) ->
  try
    report url
    original = gm(url)
      .gravity('Center')
      .background('transparent')
      .resize(241, 108)
      .extent(241, 108)
        
    original.write ".#{id}.png", (err) ->
      if err
        report err if err
        gm(241, 108, 'transparent')
          .write ".#{id}.png", (err) ->
            report err if err
            callback()
      else
        callback()
        #headers =
          #'x-amz-acl': 'public-read'
          #'Content-Length': source.headers['content-length']
          #'Content-Type': source.headers['content-type']
        #report "uploading to '#{id}'"
        #store.putStream(source, id, headers, callback)
          #.on('error', report)
  catch ex
    report ex

update_logos = (db, directories, callback) ->

  clientId = (name) ->
    name.toLowerCase().replace /[^a-z0-9]+/g, '-'

  saveLogo = (space, callback) ->
    report = (info) -> console.log "#{space.name}: #{info}"
    url = "#{process.env.LOGO_BASE_URL}#{clientId(space.name)}"
    id = "/open/#{clientId(space.name)}"
    upload url, id, report, callback

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
        async.forEach spaces, saveLogo, callback

database.connect 'directories', (err, db, directories) ->
  if err
    console.log err
    process.exit()
  else
    update_logos db, directories, (err) ->
      console.log err
      process.exit()
