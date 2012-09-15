data =
  spaces: [
    {status: {contact: {twitter: '@user'}}}
    {status: {contact: {twitter: 'hackerspace'}}}
  ]

screenNames = require '../lib/twitterScreenNames'

database = require('../database')({name: 'test'})
connection = null

module.exports =

  setUp: (done) ->
    require('../database')({name: 'test'}).connect (err, db) ->
      connection = db
      if err
        done()
      else
        require('../database/create') db, data, (err) ->
          console.log err if err
          done()

  tearDown: (done) ->
    done()

  screenNamesContainUserWithOutAtSymbol: (test) ->
    screenNames connection, (err, screenNames) ->
      test.notEqual -1, screenNames.indexOf('user')
      test.done(err)

  screenNamesContainHackerspaceEvenWhenAtNotSaved: (test) ->
    screenNames connection, (err, screenNames) ->
      test.notEqual(
        -1, screenNames.indexOf('hackerspace'),
        "'hackerspace' not included")
      test.done(err)
