module.exports = (db, names, callback) ->
  spaces = db.collection 'spaces'
  getLogoUrl = (name, callback) ->
    spaces.findOne(
      {"status.space": name},
      {"status.space": 1, "status.logo": 1},
      (err, result) ->
        console.log err if err
        callback err, result
    )
  async = require('async')
  async.map names, getLogoUrl, (err, result) ->
    logos = {}
    for value in result
      logos[value.status.space] = value.status.logo if value
    callback err, logos
