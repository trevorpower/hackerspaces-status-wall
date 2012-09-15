database =
  spaces: [
    {status: {contact: {twitter: '@user'}}}
  ]

twitterScreenNames = (callback) ->
  require('../database').connect 'test', (err, db) ->
    if err
      console.log err
    else
      db.command
        distinct: "spaces"
        key: "status.contact.twitter",
        (err, result) ->
          callback result.values.map((s) -> s.substring(1))


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
    twitterScreenNames (screenNames) ->
      test.deepEqual screenNames, ['user']
      test.done()
