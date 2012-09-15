database =
  spaces: [
    {status: {contact: {twitter: '@user'}}}
  ]

screenNames = require '../lib/twitterScreenNames'

module.exports =

  setUp: (done) ->
    require('../database').connect 'test', (err, db) ->
      if err
        done()
      else
        require('../database/create') db, database, (err) ->
          console.log err if err
          done()

  tearDown: (done) ->
    done()

  test_test: (test) ->
    screenNames (screenNames) ->
      test.deepEqual screenNames, ['user']
      test.done()
