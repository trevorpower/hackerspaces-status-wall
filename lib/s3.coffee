knox = require 'knox'

module.exports = () ->

  client = knox.createClient
    key: process.env.S3_KEY
    secret: process.env.S3_SECRET
    bucket: process.env.S3_BUCKET
    region: process.env.S3_REGION

  putStream: (args...) -> client.putStream(args...)
  putBuffer: (args...) -> client.putBuffer(args...)

