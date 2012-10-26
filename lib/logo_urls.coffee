module.exports = (db, names, callback) ->
  spaces = db.collection 'spaces'
  getLogoUrl = (name, callback) ->
    spaces.findOne(
      {"status.space": name},
      {"status.space": 1, "status.logo": 1},
      (err, result) ->
        console.log err if err
        if result
          callback err,
            name: name
            url: result.status.logo
        else
          callback err,
            name: name
            url: null
    )
  async = require('async')
  async.map names, getLogoUrl, (err, result) ->
    console.log result
    logos = {}
    for value in result
      logos[value.name] = value.url
    callback err, logos
