with_directories = (callback) ->
  require('./database').connect (err, db) ->
    if !err
      db.collection 'directories', (err, collection) ->
        callback collection if !err
    else
      callback null


exports.store = (spaces, callback) ->
  with_directories (directories) ->
    directories.insert {date: new Date(), spaces: spaces}, (err) ->
      callback(err)

exports.latest = (callback) ->
  with_directories (directories) ->
    directories
      .find()
      .sort({$natural: -1})
      .limit(1)
      .toArray (err, items) ->
        callback items[0] if !err
