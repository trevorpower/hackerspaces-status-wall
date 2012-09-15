database =
  spaces: [
    {contact: {twitter: '@user'}}
  ]

twitterScreenNames = (callback) ->
  require('../database').connect (err, db) ->
    if err
      console.log err
    else
      db.command
        distinct: "spaces"
        key: "status.contact.twitter",
        (err, result) ->
          console.log result 
          callback result.values#.map((s) -> s.substring(1))


module.exports =

  setUp: (done) ->
    console.log 'setUp'
    require('../database').connect (err, db) ->
      require('../database/create') db, database, (err) ->
        done()

  tearDown: (done) ->
    done()

  test_test: (test) ->
    twitterScreenNames (screenNames) ->
      test.ok screenNames == ['user']
      test.done()
