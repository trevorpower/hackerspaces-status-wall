request = require 'request'
async = require 'async'

module.exports = (callback) ->
  store =
    if process.env.S3_BUCKET
      console.log "Using S3 storage - #{process.env.S3_BUCKET}"
      require('../lib/s3')
    else
      console.log 'Using local storage'
      require('../local/store')

  mongojs = require 'mongojs'

  gm = require('gm').subClass imageMagic: true

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
    report id
    image.stream 'PNG', (err, dataStream, errorStream) ->
      if err
        callback arr
      else
        imageBuffer = new Buffer(400000)
        imageSize = 0
        dataStream.on 'data', (data) ->
          report 'data'
          data.copy(imageBuffer, imageSize)
          imageSize += data.length

        errorBuffer = new Buffer(10000)
        errorSize = 0
        errorStream.on 'data', (data) ->
          report 'error'
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
    report url
    uploadImage openLogo(url), id, report, (err) ->
      if err
        report "custom logo failed, uploading defualt logo"
        uploadImage defaultLogo(), id, report, callback
      else
        callback()

  saveLogo = (space, callback) ->
    report = (info) -> console.log "#{space.name}: #{info}"
    url = "#{process.env.LOGO_BASE_URL}original/#{space.slug}"
    id = "/open/#{space.slug}"
    upload url, id, report, callback

  query =
    logo:
      $exists: true
      $ne: null

  db.spaces.find query, (err, spaces) ->
    async.forEachSeries spaces, saveLogo, (err) ->
      console.log err if err
      callback()
