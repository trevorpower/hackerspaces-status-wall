knox = require 'knox'

client = knox.createClient
  key: process.env.S3_KEY
  secret: process.env.S3_SECRET
  bucket: process.env.S3_BUCKET
  region: process.env.S3_REGION
  secure: false

module.exports =
  putStream: (args...) -> client.putStream(args...)
  putBuffer: (args...) -> client.putBuffer(args...)

