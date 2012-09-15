database =
  spaces: [
    {status: {contact: {twitter: '@user'}}}
  ]

screenNames = require '../lib/twitterScreenNames'

testDb = null

module.exports =

  setUp: (done) ->
    require('../database').connect 'test', (err, db) ->
      testDb = db
      if err
        done()
      else
        require('../database/create') db, database, (err) ->
          console.log err if err
          done()

  tearDown: (done) ->
    done()

  screenNamesContainSingleUser: (test) ->
    screenNames testDb, (err, screenNames) ->
      test.deepEqual screenNames, ['user']
      test.done(err)
