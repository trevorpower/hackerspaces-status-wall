request = require 'request'
async = require 'async'
mongojs = require 'mongojs'
store = require('knox').createClient require('../s3_settings')
gm = require 'gm'

db = mongojs process.env.MONGO_URL, ['spaces']

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

clientId = (name) ->
  name.toLowerCase().replace /[^a-z0-9]+/g, '-'

saveLogo = (space, callback) ->
  report = (info) -> console.log "#{space.name}: #{info}"
  url = "#{process.env.LOGO_BASE_URL}#{clientId(space.name)}"
  id = "/open/#{clientId(space.name)}"
  upload url, id, report, callback

query =
  logo:
    $exists: true
    $ne: null

db.spaces.find query, (err, spaces) ->
  async.forEachSeries spaces, saveLogo, (err) ->
    console.log err if err
    process.exit()
