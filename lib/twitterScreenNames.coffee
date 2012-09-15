module.exports = (db, callback) ->
  db.command
    distinct: "spaces"
    key: "status.contact.twitter",
    (err, result) ->
      callback err, result.values.map((s) -> s.substring(1))
