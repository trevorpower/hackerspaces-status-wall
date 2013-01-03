request = require 'request'
mongojs = require 'mongojs'
async = require 'async'

store =
  if process.env.S3_BUCKET
    console.log "Using S3 storage - #{process.env.S3_BUCKET}"
    require('../lib/s3')
  else
    console.log 'Using local storage'
    require('../local/store')

request = require 'request'

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

saveLogo = (space, callback) ->
  report = (info) -> console.log "#{space.name}: #{info}"
  if space.logo
    id = "/original/#{space.slug}"
    upload space.logo, id, report, callback
  else
    report "no URL"
    callback()

query =
  logo:
    $exists: true
    $ne: null

db.spaces.find query, (err, spaces) ->
  if err
    console.log err
    process.exit()
  else
    async.forEach spaces, saveLogo, (err) ->
      console.log err if err
      process.exit()
