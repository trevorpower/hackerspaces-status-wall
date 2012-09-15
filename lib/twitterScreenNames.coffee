module.exports = (callback) ->
  require('../database').connect 'test', (err, db) ->
    if err
      console.log err
    else
      db.command
        distinct: "spaces"
        key: "status.contact.twitter",
        (err, result) ->
          callback result.values.map((s) -> s.substring(1))
