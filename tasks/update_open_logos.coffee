database = require('../database/database') require('../database/settings/production')

async = require 'async'
query = require '../lib/logo_urls'
store = require('knox').createClient require('../s3_settings')
request = require 'request'
gm = require 'gm'
fs = require 'fs'

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

defaultLogo = () ->
  gm(241, 108, 'transparent')

openLogo = (url) ->
  gm(url)
  .gravity('Center')
  .background('transparent')
  .resize(241, 108)
  .extent(241, 108)

uploadImage = (image, id, report, callback) ->
  image.stream 'PNG', (err, dataStream, errorStream) ->
    out = fs.createWriteStream "./#{id}.png"
    if err
      callback arr
    else

      imageBuffer = new Buffer(1000000)
      imageSize = 0
      dataStream.on 'data', (data) ->
        data.copy(imageBuffer, imageSize)
        imageSize += data.length

      errorBuffer = new Buffer(10000)
      errorSize = 0
      errorStream.on 'data', (data) ->
        data.copy(errorBuffer, errorSize)
        errorSize += data.length

      dataStream.on 'end', (err) ->
        if errorSize
          callback(errorBuffer)
        else
          headers =
            'x-amz-acl': 'public-read'
            'Content-Type': 'image/png'
          #out.write imageBuffer.slice(0, imageSize), callback
          store.putBuffer(imageBuffer.slice(0, imageSize), id, headers, callback)
            .on('error', report)

upload = (url, id, report, callback) ->
  try
    report url
    uploadImage openLogo(url), id, report, (err) ->
      if err
        report "cutom logo failed, uploading defualt logo"
        uploadImage defaultLogo(), id, report, callback
      else
        callback()
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
        async.forEachSeries spaces, saveLogo, callback

database.connect 'directories', (err, db, directories) ->
  if err
    console.log err
    process.exit()
  else
    update_logos db, directories, (err) ->
      console.log err
      process.exit()
