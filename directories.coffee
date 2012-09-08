with_directories = (callback) ->
  require('./database').connect (err, db) ->
    if !err
      db.collection 'directories', (err, collection) ->
        callback err, collection if !err
    else
      callback err

exports.latest = (callback) ->
  with_directories (directories) ->
    directories
      .find()
      .sort({$natural: -1})
      .limit(1)
      .toArray (err, items) ->
        callback items[0] if !err
