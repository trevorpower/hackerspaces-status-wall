dbOptions = {name: 'hackerspaces-me'}
database = require('../database')(dbOptions)
  
database.connect , (err, db) ->
  if err
    console.log err
    process.exit()
  else
    require('../database/create') db, {}, (err) ->
      console.log err if err
      process.exit()
