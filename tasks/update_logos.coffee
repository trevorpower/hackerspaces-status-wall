request = require 'request'
mongojs = require 'mongojs'
async = require 'async'
store = require('knox').createClient require('../s3_settings')

db = mongojs process.env.MONGO_URL, ['spaces']

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

clientId = (name) ->
  name.toLowerCase().replace /[^a-z0-9]+/g, '-'

saveLogo = (space, callback) ->
  report = (info) -> console.log "#{space.name}: #{info}"
  if space.logo
    id = "/original/#{clientId(space.name)}"
    upload space.logo, id, report, callback
  else
    report "no URL"
    callback()

query =
  logo:
    $exists: true
    $ne: null

db.spaces.find query, (err, spaces) ->
  async.forEach spaces, saveLogo, (err) ->
    console.log err if err
    process.exit()
