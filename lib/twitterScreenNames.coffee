module.exports = (db, callback) ->
  require('../database').connect 'test', (err, db) ->
    if err
      callback err
    else
      db.command
        distinct: "spaces"
        key: "status.contact.twitter",
        (err, result) ->
          callback err, result.values.map((s) -> s.substring(1))
