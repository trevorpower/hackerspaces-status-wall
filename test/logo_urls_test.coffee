data =
  spaces: [
    {status: {space: 'milklabs', logo: "http://mlkl.bz/logo.png"}}
    {status: {space: 'tog', logo: "http://example.com/logo.png"}}
  ]

logoUrls = (db, names, callback) ->
  spaces = db.collection 'spaces'
  getLogoUrl = (name, callback) ->
    spaces.findOne(
      {"status.space": name},
      {"status.space": 1, "status.logo": 1},
      callback
    )
  async = require('async')
  async.map names, getLogoUrl, (err, result) ->
    logos = {}
    for value in result
      logos[value.status.space] = value.status.logo
    callback err, logos
    

database = require('../database/database') require('../database/settings/test')

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
    logoUrls connection, ['milklabs', 'tog'], (err, urls) ->
      test.ok urls
      test.equal urls['milklabs'], "http://mlkl.bz/logo.png"
      test.done(err)
