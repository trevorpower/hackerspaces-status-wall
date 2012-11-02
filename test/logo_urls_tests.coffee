data =
  spaces: [
    {status: {space: 'milklabs', logo: "http://mlkl.bz/logo.png"}}
    {status: {space: 'tog', logo: "http://example.com/logo.png"}}
  ]

query = require '../lib/logo_urls'

database = require('../database/database') require('./db_settings')

connection = null

module.exports =

  setUp: (done) ->
    database.connect (err, db) ->
      connection = db
      if err
        done(err)
      else
        require('../database/create') db, data, (err) ->
          console.log err if err
          done()

  tearDown: (done) ->
    connection.close()
    done()

  correctUrlIsReturnedForMilkLabs: (test) ->
    query connection, ['milklabs', 'tog'], (err, urls) ->
      test.ok urls
      test.equal urls['milklabs'], "http://mlkl.bz/logo.png"
      test.done(err)
