database =
  spaces: [
    {status: {contact: {twitter: '@user'}}}
    {status: {contact: {twitter: 'hackerspace'}}}
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

  screenNamesContainUserWithOutAtSymbol: (test) ->
    screenNames testDb, (err, screenNames) ->
      test.notEqual -1, screenNames.indexOf('user')
      test.done(err)

  screenNamesContainHackerspaceEvenWhenAtNotSaved: (test) ->
    screenNames testDb, (err, screenNames) ->
      test.notEqual(
        -1, screenNames.indexOf('hackerspace'),
        "'hackerspace' not included")
      test.done(err)
