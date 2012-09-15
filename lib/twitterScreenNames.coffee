normalize = (s) ->
  if s[0] == '@'
    s.substring(1)
  else
    s

module.exports = (db, callback) ->
  db.command
    distinct: "spaces"
    key: "status.contact.twitter",
    (err, result) ->
      callback err, result.values.map(normalize)
