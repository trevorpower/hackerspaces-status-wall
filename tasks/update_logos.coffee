database = require('../database/database') require('../database/settings/production')

async = require 'async'
query = require '../lib/logo_urls'
store = require('knox').createClient require('../s3_settings')
request = require 'request'

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
  report "downloading '#{url}'"
  try
    download = request url

    download.on 'error', report
    download.on 'end', () -> report "complete"

    download.on 'response', (source) ->
      if source.statusCode == 200
        headers =
          'x-amz-acl': 'public-read'
          'Content-Length': source.headers['content-length']
          'Content-Type': source.headers['content-type']
        report "uploading to '#{id}'"
        store.putStream(source, id, headers, callback)
          .on('error', report)
      else
        report "source result #{source.statusCode}"
  catch ex
    report ex

update_logos = (db, directories, callback) ->

  clientId = (name) ->
    name.toLowerCase().replace /[^a-z0-9]+/g, '-'

  saveLogo = (space, callback) ->
    report = (info) -> console.log "#{space.name}: #{info}"
    if space.url
      id = "/original/#{clientId(space.name)}"
      upload space.url, id, report, callback
    else
      report "no URL"
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
        async.forEach spaces, saveLogo, callback

database.connect 'directories', (err, db, directories) ->
  if err
    console.log err
    process.exit()
  else
    update_logos db, directories, (err) ->
      console.log err
      process.exit()
